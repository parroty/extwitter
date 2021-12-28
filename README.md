# ExTwitter

[![CI](https://github.com/parroty/extwitter/actions/workflows/test_and_lint.yaml/badge.svg)](https://github.com/parroty/extwitter/actions/workflows/test_and_lint.yaml)
[![Coverage Status](http://img.shields.io/coveralls/parroty/extwitter.svg)](https://coveralls.io/r/parroty/extwitter)
[![Module Version](https://img.shields.io/hexpm/v/extwitter.svg)](https://hex.pm/packages/extwitter)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/extwitter/)
[![Total Download](https://img.shields.io/hexpm/dt/extwitter.svg)](https://hex.pm/packages/extwitter)
[![License](https://img.shields.io/hexpm/l/extwitter.svg)](https://github.com/parroty/extwitter/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/parroty/extwitter.svg)](https://github.com/parroty/extwitter/commits/master)

Twitter client library for Elixir. It uses [OAuther](https://github.com/lexmag/oauther) to call Twitter's REST API v1.1.

It only supports very limited set of functions yet. Refer to [lib/extwitter.ex](https://github.com/parroty/extwitter/blob/master/lib/extwitter.ex) and [test/extwitter_test.exs](https://github.com/parroty/extwitter/blob/master/test/extwitter_test.exs) for available functions and examples.

## Installation

The package can be installed by adding `:extwitter` to your list of
dependencies in `mix.exs`:

By default, ExTwitter uses [OAuther](https://github.com/lexmag/oauther) and
[Jason](https://github.com/michalmuskala/jason) library to call Twitter's REST
API.

```elixir
defp deps do
  [
    {:oauther, "~> 1.1"},
    {:jason, "~> 1.1"},
    {:extwitter, "~> 0.12"}
  ]
end
```

## Configuration

Refer to [Twitter API doc](https://dev.twitter.com/docs) for the detail.

The default behaviour is to configure using the application environment:

In `config/config.exs`, add:

```elixir
config :extwitter, :oauth, [
   consumer_key: "",
   consumer_secret: "",
   access_token: "",
   access_token_secret: ""
]
```

Or manually at runtime through `ExTwitter.configure/1`:

```elixir
iex> ExTwitter.configure([consumer_key: "", ...])
```

You can also configure the current process only:

```elixir
iex> ExTwitter.configure(:process, [consumer_key: "", ...])
```

You can also customize it to use another library via the `:json_library`
configuration:

```elixir
config :extwitter, :json_library, Poison
```

Proxy for accessing twitter server can be configured as follows:

```elixir
config :extwitter, :proxy, [
   server: "www-proxy.mycompany.com",
   port: 8000,
   user: "user",
   password: "password"
]
```

## Usage

Sample execution on IEx.

### Setup and configuration

```elixir
$ iex -S mix
Interactive Elixir - press Ctrl+C to exit (type h() ENTER for help)
```

```elixir
ExTwitter.configure(
   consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
   consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
   access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
   access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
 )
```

### Authentication / Authorization

Example for authentication ([Sign-in with twitter](https://dev.twitter.com/web/sign-in/implementing)).

Authorization ([3-legged authorization](https://dev.twitter.com/oauth/3-legged)) uses the same workflow, just swap `:authenticate_url` for `:authorize_url` where indicated.

```elixir
# Request twitter for a new token
token = ExTwitter.request_token("http://myapp.com/twitter-callback")

# Generate the url for "Sign-in with twitter".
# For "3-legged authorization" use ExTwitter.authorize_url instead
{:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

# Copy the url, paste it in your browser and authenticate
IO.puts authenticate_url
```

After sign-in you will be redirected to the callback URL you configured for
your app. Get the tokens from the URL's query:

```
https://myapp.com/twitter-callback?oauth_token=<TOKEN>&oauth_verifier=<VERIFIER>
```

Copy the `oauth_token` and `oauth_verifier` query strings from the URL and use
it in the IEx snippet below.

```elixir
oauth_token = "<TOKEN>"
oauth_verifier = "<VERIFIER>"

# Exchange for an access token
{:ok, access_token} = ExTwitter.access_token(oauth_verifier, oauth_token)

# Configure ExTwitter to use your newly obtained access token
ExTwitter.configure(
  consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
  consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
  access_token: access_token.oauth_token,
  access_token_secret: access_token.oauth_token_secret
)

ExTwitter.user_timeline
```

### Searching

Example for normal API.

```elixir
iex> ExTwitter.search("elixir-lang", [count: 5]) |>
     Enum.map(fn(tweet) -> tweet.text end) |>
     Enum.join("\n-----\n") |>
     IO.puts

# => Tweets will be displayed in the console as follows.
@xxxx have you tried this yet?
-----
@yyyy You mean this? http://t.co/xxxx That had sailed below my radar thus far.
-----
@zzzz #elixir-lang. I'm jadams
-----
Akala ko 100 nalang kulang ko sa dark elixir para sa Barb King summoner level.
-----
@aaaa usually kasi magbbuzz lang yan pag luma na string. talaga ang elixir.
```

### Streaming

Example for streaming API.

```elixir
stream = ExTwitter.stream_filter(track: "apple") |>
Stream.map(fn(x) -> x.text end) |>
Stream.map(fn(x) -> IO.puts "#{x}\n---------------\n" end)

Enum.to_list(stream)

# => Tweets will be displayed in the console as follows.
Apple 'iWatch' rumour round-up
---------------
Apple iPhone 4s 16GB Black Verizon - Cracked Screen, WORKS PERFECTLY!
---------------
Apple iPod nano 7th Generation (PRODUCT) RED (16 GB) (Latest Model) - Full read by
---------------
...
```

The `ExTwitter.stream_control/2` function to send a message to stop the stream.

```elixir
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

Twitter returns several [streaming message types](https://dev.twitter.com/streaming/overview/messages-types"). These messages are returned when `:receive_messages` option is specified.

```elixir
stream = ExTwitter.stream_sample(receive_messages: true)

for message <- stream do
  case message do
    tweet = %ExTwitter.Model.Tweet{} ->
      IO.puts "tweet = #{tweet.text}"

    deleted_tweet = %ExTwitter.Model.DeletedTweet{} ->
      IO.puts "deleted tweet = #{deleted_tweet.status[:id]}"

    limit = %ExTwitter.Model.Limit{} ->
      IO.puts "limit = #{limit.track}"

    stall_warning = %ExTwitter.Model.StallWarning{} ->
      IO.puts "stall warning = #{stall_warning.code}"

    _ ->
      IO.inspect message
  end
end
```

### Cursor

Some of Twitter API have paging capability for retrieving large number of items
through cursor. The following is an example to iteratively call the API to
fetch all the items.

```elixir
defmodule Retriever do
  def follower_ids(screen_name, acc \\ [], cursor \\ -1) do
    cursor = fetch_next(screen_name, cursor)
    if Enum.count(cursor.items) == 0 do
      List.flatten(acc)
    else
      follower_ids(screen_name, [cursor.items|acc], cursor.next_cursor)
    end
  end

  defp fetch_next(screen_name, cursor) do
    try do
      ExTwitter.follower_ids(screen_name, cursor: cursor)
    rescue
      e in ExTwitter.RateLimitExceededError ->
        :timer.sleep ((e.reset_in + 1) * 1000)
        fetch_next(screen_name, cursor)
    end
  end
end

ids = Retriever.follower_ids("TwitterDev")
IO.puts "Follower count for TwitterDev is #{Enum.count(ids)}."
# => Follower count for TwitterDev is 38469.
```

## Development

`run_iex.sh` launches IEx, with initially calling `ExTwitter.configure/1` defined
as `iex/dot.iex`.

```elixir
$ ./run_iex.sh
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:4:4] [async-threads:10]...
Interactive Elixir (1.0.2) - press Ctrl+C to exit (type h() ENTER for help)

iex> (ExTwitter.search("elixir") |> List.first).text
```

## Copyright and License

Copyright (c) 2014 parroty

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
