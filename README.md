# ExTwitter [![Build Status](https://secure.travis-ci.org/parroty/extwitter.png?branch=master "Build Status")](http://travis-ci.org/parroty/extwitter)

Twitter client library for elixir. It uses <a href="https://github.com/tim/erlang-oauth/" target="_blank">erlang-oauth</a> to call Twitter's REST API.

It only supports very limited set of functions yet. Refer to `lib/extwitter.ex` for available functions.

### Usage
1. Use `ExTwitter.configure` to setup Twitter's OAuth authentication paramters. Refer to https://dev.twitter.com/docs for the detail.

2. Call functions in ExTwitter module (ex. `ExTwitter.search("test")`)

### Sample

```Elixir
Interactive Elixir - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> ExTwitter.configure(
...(1)>   consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
...(1)>   consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
...(1)>   access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
...(1)>   access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
...(1)> )

iex(2)> ExTwitter.search("elixir-lang", [count: 5]) |>
...(2)>   Enum.map(fn(tweet) -> tweet.text end) |>
...(2)>   Enum.join("\n-----\n") |>
...(2)>   IO.puts
@feyeleanor have you tried this yet? http://t.co/ehYtIcPzlX
-----
@mwotton You mean this? http://t.co/BaeMcVRRMb That had sailed below my radar thus far.
-----
@edmz #elixir-lang. I'm jadams
-----
Akala ko 100 nalang kulang ko sa dark elixir para sa Barb King summoner level. Medyo naexcite lang.
-----
@KANGKINGKONG_ usually kasi magbbuzz lang yan pag luma na string. talaga ang elixir.
```



