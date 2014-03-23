# ExTwitter [![Build Status](https://secure.travis-ci.org/parroty/extwitter.png?branch=master "Build Status")](http://travis-ci.org/parroty/extwitter)

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
```Elixir
ExTwitter.search("elixir-lang", [count: 5]) |>
   Enum.map(fn(tweet) -> tweet.text end) |>
   Enum.join("\n-----\n") |>
   IO.puts

@feyeleanor have you tried this yet? http://t.co/ehYtIcPzlX
-----
@mwotton You mean this? http://t.co/BaeMcVRRMb That had sailed below my radar thus far.
-----
@edmz #elixir-lang. I'm jadams
-----
Akala ko 100 nalang kulang ko sa dark elixir para sa Barb King summoner level. Medyo naexcite.
-----
@KANGKINGKONG_ usually kasi magbbuzz lang yan pag luma na string. talaga ang elixir.
:ok
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