defmodule ExTwitter.API.Streaming do
  @moduledoc """
  Provides streaming API interfaces.
  """

  @doc """
  The default timeout value (in milliseconds) for how long keeps waiting until next message arrives.
  """
  @default_stream_timeout 60_000
  @default_control_timeout 10_000

  def stream_sample(options \\ []) do
    {options, configs} = seperate_configs_from_options(options)
    params = ExTwitter.Parser.parse_request_params(options)
    pid = async_request(self, :get, "1.1/statuses/sample.json", params, configs)
    create_stream(pid, @default_stream_timeout)
  end

  def stream_filter(options, timeout \\ @default_stream_timeout) do
    {options, configs} = seperate_configs_from_options(options)
    params = ExTwitter.Parser.parse_request_params(options)
    pid = async_request(self, :post, "1.1/statuses/filter.json", params, configs)
    create_stream(pid, timeout)
  end

  defp seperate_configs_from_options(options) do
    config  = Keyword.take(options, [:receive_messages])
    options = Keyword.delete(options, :receive_messages)
    {options, config}
  end

  @doc """
  An interface to control the stream which keeps running infinitely.
  options can be used to specify timeout (ex. [timeout: 10000]).
  """
  def stream_control(pid, :stop, options \\ []) do
    timeout = options[:timeout] || @default_control_timeout

    send pid, {:control_stop, self}

    receive do
      :ok -> :ok
    after
      timeout -> :timeout
    end
  end

  defp async_request(processor, method, path, params, configs) do
    oauth = ExTwitter.Config.get_tuples |> ExTwitter.API.Base.verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}

    spawn(fn ->
      response = ExTwitter.OAuth.request_async(
        method, request_url(path), params, consumer, oauth[:access_token], oauth[:access_token_secret])

      case response do
        {:ok, request_id} ->
          process_stream(processor, request_id, configs)
        {:error, reason} ->
          send processor, {:error, reason}
      end
    end)
  end

  defp create_stream(pid, timeout) do
    Stream.resource(
      fn -> pid end,
      fn(pid) -> receive_next_tweet(pid, timeout) end,
      fn(pid) -> send pid, {:cancel, self} end)
  end

  defp receive_next_tweet(pid, timeout) do
    receive do
      {:stream, tweet} ->
        {[tweet], pid}

      {:control_stop, requester} ->
        send pid, {:cancel, self}
        send requester, :ok
        {:halt, pid}

      _ ->
        receive_next_tweet(pid, timeout)
    after
      timeout ->
        send pid, {:cancel, self}
        {:halt, pid}
    end
  end

  @doc false
  def process_stream(processor, request_id, configs, acc \\ []) do
    receive do
      {:http, {request_id, :stream_start, headers}} ->
        send processor, {:header, headers}
        process_stream(processor, request_id, configs)

      {:http, {request_id, :stream, part}} ->
        cond do
          is_empty_message(part) ->
            process_stream(processor, request_id, configs, acc)

          is_end_of_message(part) ->
            message = Enum.reverse([part|acc])
                      |> Enum.join("")
                      |> __MODULE__.parse_tweet_message(configs)
            if message do
              send processor, message
            end
            process_stream(processor, request_id, configs, [])

          true ->
            process_stream(processor, request_id, configs, [part|acc])
        end

      {:http, {_request_id, {:error, reason}}} ->
        send processor, {:error, reason}

      {:cancel, requester} ->
        :httpc.cancel_request(request_id)
        send requester, :ok

      _ ->
        process_stream(processor, request_id, configs)
    end
  end

  @crlf "\r\n"
  def is_empty_message(part),  do: part == @crlf
  def is_end_of_message(part), do: part |> String.ends_with?(@crlf)

  @doc false
  def parse_tweet_message(json, configs) do
    try do
      case ExTwitter.JSON.decode(json) do
        {:ok, tweet} ->
          if Map.has_key?(tweet, :id_str) do
            {:stream, ExTwitter.Parser.parse_tweet(tweet)}
          else
            if configs[:receive_messages] do
              parse_control_message(tweet)
            else
              nil
            end
          end

        {:error, error} ->
          {:error, {error, json}}
      end
    rescue
      error ->
        IO.inspect [error: error, json: json]
        nil
    end
  end

  defp parse_control_message(message) do
    case message do
      %{:delete => tweet} ->
        {:stream, %ExTwitter.Model.DeletedTweet{status: tweet.status}}

      %{:limit => limit} ->
        {:stream, %ExTwitter.Model.Limit{track: limit.track}}

      %{:warning => warning} ->
        {:stream, %ExTwitter.Model.StallWarning{
                    code: warning.code, message: warning.message,
                    percent_full: warning.percent_full}}

      true -> nil
    end
  end

  defp request_url(path) do
    "https://stream.twitter.com/#{path}" |> to_char_list
  end
end
