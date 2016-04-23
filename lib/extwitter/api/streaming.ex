defmodule ExTwitter.API.Streaming do
  @moduledoc """
  Provides streaming API interfaces.
  """

  @doc """
  The default timeout value (in milliseconds) for how long keeps waiting until next message arrives.
  """
  @default_stream_timeout 60_000
  @default_control_timeout 10_000

  require Logger

  defmodule AsyncRequest do
    defstruct processor: nil, method: nil, path: nil, params: nil, configs: nil
  end

  def stream_sample(options \\ []) do
    {options, configs} = seperate_configs_from_options(options)
    params = ExTwitter.Parser.parse_request_params(options)
    req = %AsyncRequest{processor: nil, method: :get, path: "1.1/statuses/sample.json", params: params, configs: configs}
    create_stream(req, @default_stream_timeout)
  end

  def stream_filter(options, timeout \\ @default_stream_timeout) do
    {options, configs} = seperate_configs_from_options(options)
    params = ExTwitter.Parser.parse_request_params(options)
    req = %AsyncRequest{processor: nil, method: :post, path: "1.1/statuses/filter.json", params: params, configs: configs}
    create_stream(req, timeout)
  end

  def stream_user(options \\ [], timeout \\ @default_stream_timeout) do
    {options, configs} = seperate_configs_from_options(options)
    params = ExTwitter.Parser.parse_request_params(options)
    req = %AsyncRequest{processor: nil, method: :get, path: "1.1/user.json", params: params, configs: configs}
    create_stream(req, timeout)
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

  defp spawn_async_request(req=%AsyncRequest{}) do
    oauth = ExTwitter.Config.get_tuples |> ExTwitter.API.Base.verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    spawn(fn ->
      response = ExTwitter.OAuth.request_async(
        req.method, request_url(req.path), req.params, consumer, oauth[:access_token], oauth[:access_token_secret])
      case response do
        {:ok, request_id} ->
          process_stream(req.processor, request_id, req.configs)
        {:error, reason} ->
          send req.processor, {:error, reason}
      end
    end)
  end

  defp create_stream(req, timeout) do
    Stream.resource(
      fn -> {%{req | processor: self}, nil} end,
      fn({req, pid}) -> receive_next_tweet(pid, req, timeout) end,
      fn({_req, pid}) ->
        if pid != nil do
          send pid, {:cancel, self}
        end
      end
    )
  end

  defp receive_next_tweet(nil, req, timeout) do
    receive_next_tweet(spawn_async_request(req), req, timeout)
  end

  defp receive_next_tweet(pid, req, timeout) do
    max_timeout = case timeout do
                    :infinity -> @default_stream_timeout
                    _ -> timeout
                  end
    receive do
      {:stream, tweet} ->
        {[tweet], {req, pid}}

      {:control_stop, requester} ->
        send pid, {:cancel, self}
        send requester, :ok
        {:halt, {req, pid}}

      {:error, :socket_closed_remotely} ->
        Logger.warn "Connection closed remotely, restarting stream"
        receive_next_tweet(nil, req, timeout)

      _ ->
        receive_next_tweet(pid, req, timeout)

    after
      max_timeout ->
        send pid, {:cancel, self}
        case timeout do
          :infinity ->
            Logger.debug "Tweet timeout, restarting stream."
            receive_next_tweet(nil, req, timeout)
          _ ->
            Logger.debug "Tweet timeout, stopping stream."
            {:halt, {req, pid}}
        end
    end
  end

  @doc false
  def process_stream(processor, request_id, configs, acc \\ []) do
    receive do
      {:http, {request_id, :stream_start, _headers}} ->
        send processor, :keepalive
        process_stream(processor, request_id, configs)

      {:http, {request_id, :stream, part}} ->
        cond do
          is_empty_message(part) ->
            send processor, :keepalive
            process_stream(processor, request_id, configs, acc)

          is_end_of_message(part) ->
            message = Enum.reverse([part|acc])
                      |> Enum.join("")
                      |> __MODULE__.parse_tweet_message(configs)
            if message != nil do
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

  defp parse_message_type(%{friends: friends}, _) do
    {:friends, friends}
  end

  defp parse_message_type(%{event: "follow"} = msg, _) do
    {:follow, msg}
  end

  defp parse_message_type(%{event: "unfollow"} = msg, _) do
    {:unfollow, msg}
  end

  defp parse_message_type(%{event: _event} = msg, _) do
    {:event, msg}
  end

  defp parse_message_type(%{text: _text} = msg, _) do
    {:msg, msg}
  end

  defp parse_message_type(msg, configs) do
    if configs[:receive_messages] do
      {:control, parse_control_message(msg)}
    else
      {:unknown, nil}
    end
  end


  @doc false
  def parse_tweet_message(json, configs) do
    try do
      case ExTwitter.JSON.decode(json) do
        {:ok, tweet} ->
          case parse_message_type(tweet,configs) do
            {:msg, _}       -> {:stream, ExTwitter.Parser.parse_tweet(tweet)}
            {:follow, _}     -> {:stream, {:follow, tweet}}
            {:unfollow, _}  -> {:stream, {:unfollow, tweet}}
            {:event, _}     -> {:stream, {:event, tweet}}
            {:friends, _}   -> {:stream, {:friends, tweet}}
            {:control, msg} -> msg
            {:unknown, _}   -> nil
          end
        {:error, error} -> {:error, {error, json}}
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
  defp request_url("1.1/user.json" = path) do
    "https://userstream.twitter.com/#{path}" |> to_char_list
  end

  defp request_url(path) do
    "https://stream.twitter.com/#{path}" |> to_char_list
  end
end
