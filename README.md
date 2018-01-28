# ExTwitter [![Build Status](https://img.shields.io/travis/parroty/extwitter.svg "Build Status")](http://travis-ci.org/parroty/extwitter) [![Coverage Status](http://img.shields.io/coveralls/parroty/extwitter.svg)](https://coveralls.io/r/parroty/extwitter) [![Deps Status](https://beta.hexfaktor.org/badge/all/github/parroty/extwitter.svg)](https://beta.hexfaktor.org/github/parroty/extwitter) [![Inline docs](http://inch-ci.org/github/parroty/extwitter.svg?branch=master&style=flat)](http://inch-ci.org/github/parroty/extwitter)

Twitter client library for elixir. It uses <a href="https://github.com/lexmag/oauther" target="_blank">oauther</a> to call Twitter's REST API.

It only supports very limited set of functions yet. Refer to <a href="https://github.com/parroty/extwitter/blob/master/lib/extwitter.ex" target="_blank">lib/extwitter.ex</a> and <a href="https://github.com/parroty/extwitter/blob/master/test/extwitter_test.exs" target="_blank">test/extwitter_test.exs</a> for available functions and examples.

### Documentation
  * http://hexdocs.pm/extwitter

### Usage
1. Add `extwitter` to deps section in the `mix.exs`.
2. Use `ExTwitter.configure` to setup Twitter's OAuth authentication parameters. Refer to https://dev.twitter.com/docs for the detail.
3. Call functions in ExTwitter module (ex. `ExTwitter.search("test")`).

#### Configuration

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

Or manually at runtime:

```elixir
ExTwitter.configure([consumer_key: "", ...])
```

You can also configure the current process only:

```elixir
ExTwitter.configure(:process, [consumer_key: "", ...])
```

#### mix.exs
```elixir
defp deps do
  [
    {:oauther, "~> 1.1"},
    {:extwitter, "~> 0.8"}
  ]
end

...

def application do
  [applications: [:logger, :extwitter]]
end
```

### Sample
Sample execution on iex.

#### configure
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
#### search
Example for normal API.
```Elixir
ExTwitter.search("elixir-lang", [count: 5]) |>
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
:ok
```

#### streaming
Example for streaming API.
```Elixir
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

Twitter returns several message types (<a href="https://dev.twitter.com/streaming/overview/messages-types" target="_blank">dev.twitter.com - Streaming message types</a>). These messages are returned when `receive_messages` option is specified.

```Elixir
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

#### cursor
Some of Twitter API have paging capability for retrieving large number of items through cursor. The following is an example to iteratively call the API to fetch all the items.

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

#### authentication / authorization

Example for authentication ([Sign-in with twitter](https://dev.twitter.com/web/sign-in/implementing)). Authorization ([3-legged authorization](https://dev.twitter.com/oauth/3-legged)) uses the same workflow, just swap `authenticate_url` for `authorize_url` where indicated.

```elixir
# Request twitter for a new token
token = ExTwitter.request_token("http://myapp.com/twitter-callback")

# Generate the url for "Sign-in with twitter".
# For "3-legged authorization" use ExTwitter.authorize_url instead
{:ok, authenticate_url} = ExTwitter.authenticate_url(token.oauth_token)

# Copy the url, paste it in your browser and authenticate
IO.puts authenticate_url
```

After sign-in you will be redirected to the callback URL you configured for your app.

Example:

<pre>http://myapp.com/twitter-callback?oauth_token=<b>copy_this</b>&amp;oauth_verifier=<b>copy_this_too</b></pre>

Copy the oauth_token and oauth_verifier query strings from the URL and use it in the iex snippet below.

```elixir
oauth_token = "copy_this"
oauth_verifier = "copy_this_too"

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

#### proxy
Proxy for accessing twitter server can be configured as follows.

In `config/config.exs`,
```elixir
use Mix.Config

config :extwitter, :proxy, [
   server: "www-proxy.mycompany.com",
   port: 8000,
   user: "user",
   password: "password"
]
```

### Notes
`run_iex.sh` launches iex, with initially calling `ExTwitter.configure` defined as `iex/dot.iex`.

```Elixir
$ ./run_iex.sh
Erlang/OTP 17 [erts-6.3] [source] [64-bit] [smp:4:4] [async-threads:10]...
Interactive Elixir (1.0.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> (ExTwitter.search("elixir") |> List.first).text
...
```
