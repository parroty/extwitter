defmodule ExTwitter.API.Streaming.Process.Bench do
  use Benchfella
  import ExTwitter.API.Streaming

  @mock_tweet_json File.read!("fixture/mocks/tweet.json")

  setup_all do
    :meck.new(ExTwitter.API.Streaming, [:passthrough, :no_history])
    {:ok, nil}
  end

  before_each_bench _ do
    :meck.expect(
      ExTwitter.API.Streaming, :parse_tweet_message,
      fn(_,_) -> :parsed end
    )
    {:ok, nil}
  end

  after_each_bench _ do
    :meck.unload(ExTwitter.API.Streaming)
  end

  bench "process stream - single chunk", [req_id: make_ref()] do
    streamProcessor = spawn_stream_processor(self(), req_id)
    send streamProcessor, {:http, {req_id, :stream, @mock_tweet_json}}
    receive_processed_msgs()
  end

  bench "process stream - multi chunk", [req_id: make_ref(), parts: msg_chunks()] do
    streamProcessor = spawn_stream_processor(self(), req_id)
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

  # fake chunked messages to emulate chunked network traffic
  defp msg_chunks, do: chunkify(@mock_tweet_json, 20)
  defp chunkify(msg, n) do
    chars = String.graphemes(msg)
    chunksize = trunc(length(chars)/n)+1

    Enum.chunk(chars, chunksize, chunksize, [])
    |> Enum.map(&Enum.join/1)
  end

end
