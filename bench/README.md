Note about these benchmarks:

The `stream_process_bench.exs` script uses Meck to stub out the
`ExTwitter.API.Streaming.parse_tweet` function for benchmark isolation.

However, benchfella does not currently support teardown phases to undo this
stub after the completion of the bench.

Therefore, if you run them all via the default `mix bench` task (which loads and
runs all benchmarks in this directory), other benchmarks which depend on that
call will get unexpected results.

For now, just run each benchmark script you want individually directly, e.g.

    mix bench bench/stream_parse_bench.exs

Sorry for the inconvenience!
