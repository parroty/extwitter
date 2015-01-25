defmodule ExTwitter.API.Streaming.Process.Bench do
  use Benchfella
  import ExTwitter.API.Streaming

  @mock_tweet_json File.read!("fixture/mocks/tweet.json")

  bench "process stream - single chunk", [req_id: make_ref, m: stub_tweet_parsing!] do
    streamProcessor = spawn_stream_processor(self, req_id)
    send streamProcessor, {:http, {req_id, :stream, @mock_tweet_json}}
    receive_processed_msgs()
  end

  bench "process stream - multi chunk", [req_id: make_ref, parts: msg_chunks, m: stub_tweet_parsing!] do
    streamProcessor = spawn_stream_processor(self, req_id)
    Enum.each(parts, fn part ->
      send streamProcessor, {:http, {req_id, :stream, part}}
    end)
    receive_processed_msgs()
  end

  defp spawn_stream_processor(receiver, req_id) do
    spawn(fn ->
      process_stream(receiver, req_id, [])
    end)
  end

  # block until we receive a message from the stream reader, raise exception
  # if something unexpected happens
  defp receive_processed_msgs do
    receive do
      :parsed      -> :ok #mock parsed msg
      {:stream, _} -> :ok #real parsed msg
      _msg         -> raise "got unexpected message back from stream processor!"
    after 1000
      -> raise "timed out waiting for stream processor!"
    end
  end

  # stub out tweet parsing so it doesnt affect benchmark time
  # this is a fairly bad way to do it, but benchfella doesnt support a global
  # "setup" phase just yet.
  #
  # also note that since benchfella doesn't support "after" callbacks to unload
  # stubs, this stays loaded, so we all benchmarks in this file should be
  # considered as using the stub.
  defp stub_tweet_parsing! do
    try do
      :meck.validate(ExTwitter.API.Streaming)
    rescue
      ErlangError ->
        Mix.Shell.IO.info """
        WARNING! We just stubbed ExTwitter.API.Streaming.parse_tweet_message
        This stub will be effect until this process ends.

        If you are running multiple benchmarks, these ones should be run
        independently of others, you can specify the files to run directly via
        `mix bench bench/filename_bench.exs` etc.
        """
        :meck.new(ExTwitter.API.Streaming, [:passthrough, :no_history])
        :meck.expect(
          ExTwitter.API.Streaming, :parse_tweet_message,
          fn(_,_) -> :parsed end
        )
    end
  end

  # fake chunked messages to emulate chunked network traffic
  defp msg_chunks, do: chunkify(@mock_tweet_json, 20)
  defp chunkify(msg, n) do
    chars = String.graphemes(msg)
    chunksize = trunc(length(chars)/n)+1

    Enum.chunk(chars, chunksize, chunksize, [])
    |> Enum.map(&Enum.join/1)
  end

end
