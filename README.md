# ExTwitter [![Build Status](https://secure.travis-ci.org/parroty/extwitter.png?branch=master "Build Status")](http://travis-ci.org/parroty/extwitter) [![Coverage Status](https://coveralls.io/repos/parroty/extwitter/badge.png?branch=master)](https://coveralls.io/r/parroty/extwitter?branch=master)

Twitter client library for elixir. It uses <a href="https://github.com/tim/erlang-oauth/" target="_blank">erlang-oauth</a> to call Twitter's REST API.

It only supports very limited set of functions yet. Refer to <a href="https://github.com/parroty/extwitter/blob/master/lib/extwitter.ex" target="_blank">lib/extwitter.ex</a> and <a href="https://github.com/parroty/extwitter/blob/master/test/extwitter_test.exs" target="_blank">test/extwitter_test.exs</a> for available functions and examples.

### Usage
1. Use `ExTwitter.configure` to setup Twitter's OAuth authentication paramters. Refer to https://dev.twitter.com/docs for the detail.
2. Call functions in ExTwitter module (ex. `ExTwitter.search("test")`).

### Sample
Sample execution on iex.

```Elixir
$ iex -S mix
Interactive Elixir - press Ctrl+C to exit (type h() ENTER for help)
```
```Elixir
ExTwitter.configure(
   consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
   consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
   access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
   access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
)

:ok
```
Example for normal API.
```Elixir
ExTwitter.search("elixir-lang", [count: 5]) |>
   Enum.map(fn(tweet) -> tweet.text end) |>
   Enum.join("\n-----\n") |>
   IO.puts

@xxxx have you tried this yet?
-----
@yyyy You mean this? http://t.co/xxxx That had sailed below my radar thus far.
-----
@zzzz #elixir-lang. I'm jadams
-----
Akala ko 100 nalang kulang ko sa dark elixir para sa Barb King summoner level.
-----
@aaaa usually kasi magbbuzz lang yan pag luma na string. talaga ang elixir.
:ok
```
Example for streaming API.
```Elixir
stream = ExTwitter.stream_filter(track: "apple") |>
  Stream.map(fn(x) -> x.text end) |>
  Stream.map(fn(x) -> IO.puts "#{x}\n---------------\n" end)
Enum.to_list(stream)

Apple 'iWatch' rumour round-up
---------------
Apple iPhone 4s 16GB Black Verizon - Cracked Screen, WORKS PERFECTLY!
---------------
Apple iPod nano 7th Generation (PRODUCT) RED (16 GB) (Latest Model) - Full read by
---------------
...
...
```

The `ExTwitter.stream_control` method allows to send a message to stop the stream.

```Elixir
# An example to stop receiving stream after 5 seconds passed.
pid = spawn(fn ->
  stream = ExTwitter.stream_filter(track: "apple")
  for tweet <- stream do
    IO.puts tweet.text
  end
end)

:timer.sleep(5000)
ExTwitter.stream_control(pid, :stop)
```

### Notes
`run_iex.sh` launches iex, with initially calling `ExTwitter.configure` defined as `iex/dot.iex`.

```Elixir
$ ./run_iex.sh
Erlang R16B03 (erts-5.10.4) [source] [64-bit] [smp:4:4] [async-threads:10]...
Interactive Elixir (0.12.4) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> (ExTwitter.search("josevalim") |> List.first).text
...
```