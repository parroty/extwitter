defmodule ExTwitter.API.Streaming do
  @moduledoc """
  Provides streaming API interfaces.
  """

  @default_timeout 60_000

  @doc """
  Returns a small random sample of all public statuses.
  This method returns the Stream that holds the list of tweets.
  """
  def stream_sample(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    pid = async_request(self, :get, "1.1/statuses/sample.json", params)
    create_stream(pid, @default_timeout)
  end

  @doc """
  Returns public statuses that match one or more filter predicates.
  This method returns the Stream that holds the list of tweets.
  Specify at least one of the [follow, track, locations] options.
  """
  def stream_filter(options, timeout \\ @default_timeout) do
    params = ExTwitter.Parser.parse_request_params(options)
    pid = async_request(self, :post, "1.1/statuses/filter.json", params)
    create_stream(pid, timeout)
  end

  defp async_request(processor, method, path, params) do
    oauth = ExTwitter.Config.get_tuples |> ExTwitter.API.Base.verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}

    spawn(fn ->
      response = ExTwitter.OAuth.request_async(
        method, request_url(path), params, consumer, oauth[:access_token], oauth[:access_token_secret])

      case response do
        {:ok, request_id} ->
          process_stream(processor, request_id)
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
      {:stream, tweet} -> {tweet, pid}
      _other -> receive_next_tweet(pid, timeout)
    after
      timeout ->
        send pid, {:cancel, self}
        nil
    end
  end

  defp process_stream(processor, request_id, acc \\ []) do
    receive do
      {:http, {request_id, :stream_start, headers}} ->
        send processor, {:header, headers}
        process_stream(processor, request_id)

      {:http, {request_id, :stream, part}} ->
        cond do
          is_empty_message(part) ->
            process_stream(processor, request_id, acc)

          is_end_of_message(part) ->
            message = Enum.reverse([part|acc])
                        |> Enum.join("")
                        |> parse_tweet_message
            if message do
              send processor, message
            end
            process_stream(processor, request_id, [])

          true ->
            process_stream(processor, request_id, [part|acc])
        end

      {:http, {_request_id, {:error, reason}}} ->
        send processor, {:error, reason}

      {:cancel, requester} ->
        :httpc.cancel_request(request_id)
        send requester, :ok

      _ ->
        process_stream(processor, request_id)
    end
  end

  defp is_empty_message(part), do: part == "\r\n"
  defp is_end_of_message(part), do: part =~ ~r/\r\n$/

  defp parse_tweet_message(json) do
    try do
      case ExTwitter.JSON.decode(json) do
        {:ok, tweet} ->
          if ExTwitter.JSON.get(tweet, "id_str") != [] do
            {:stream, ExTwitter.Parser.parse_tweet(tweet)}
          else
            nil
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

  defp request_url(path) do
    "https://stream.twitter.com/#{path}" |> to_char_list
  end
end
