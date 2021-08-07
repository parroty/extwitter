defmodule ExTwitter do
  @moduledoc """
  Provides access interfaces for the Twitter API.
  """

  alias ExTwitter.Behaviour
  @behaviour Behaviour

  use Application

  @doc false
  @impl Application
  def start(_type, _args) do
    if Application.get_env(:ex_twitter, :oauth, nil) do
      IO.puts :stderr, "[deprecation] Using :ex_twitter in config.exs is deprecated. Use :extwitter instead."
    end
    ExTwitter.Proxy.initialize
    ExTwitter.Supervisor.start_link
  end

  # -------------- ExTwitter Settings -------------

  @doc """
  Provides OAuth configuration settings for accessing twitter server.

  The specified configuration applies globally. Use `ExTwitter.configure/2`
  for setting different configurations on each processes.

  ## Examples

      ExTwitter.configure(
        consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
        consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
        access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
      )

  """
  @impl Behaviour
  defdelegate configure(oauth), to: ExTwitter.Config, as: :set

  @doc """
  Provides OAuth configuration settings for accessing twitter server.

  ## Options

    The `scope` can have one of the following values.

    * `:global` - configuration is shared for all processes.

    * `:process` - configuration is isolated for each process.

  ## Examples

      ExTwitter.configure(
        :process,
        consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
        consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
        access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
        access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
      )

  """
  @impl Behaviour
  defdelegate configure(scope, oauth), to: ExTwitter.Config, as: :set

  @doc """
  Returns current OAuth configuration settings for accessing twitter server.
  """
  @impl Behaviour
  defdelegate configure, to: ExTwitter.Config, as: :get

  @doc """
  Provides general twitter API access interface.

  This method simply returns parsed json in Map structure.

  ## Examples

      ExTwitter.request(:get, "1.1/statuses/home_timeline.json")

  """
  @impl Behaviour
  defdelegate request(method, path), to: ExTwitter.API.Base

  @doc """
  Provides general twitter API access interface.

  This method simply returns parsed json in Map structure.

  ## Examples

      ExTwitter.request(:get, "1.1/search/tweets.json", [q: "elixir", count: 1])

  """
  @impl Behaviour
  defdelegate request(method, path, params), to: ExTwitter.API.Base

  # -------------- Timelines -------------

  @doc """
  GET statuses/mentions_timeline

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/mentions_timeline
  """
  @impl Behaviour
  defdelegate mentions_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/mentions_timeline

  ## Examples

      ExTwitter.mentions_timeline(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/mentions_timeline
  """
  @impl Behaviour
  defdelegate mentions_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/user_timeline

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/user_timeline
  """
  @impl Behaviour
  defdelegate user_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/user_timeline

  ## Examples

      ExTwitter.user_timeline(count: 1)
      ExTwitter.user_timeline([screen_name: "josevalim", count: 12])

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/user_timeline
  """
  @impl Behaviour
  defdelegate user_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/home_timeline

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/home_timeline
  """
  @impl Behaviour
  defdelegate home_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/home_timeline

  ## Examples

      ExTwitter.home_timeline(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/home_timeline
  """
  @impl Behaviour
  defdelegate home_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/retweets_of_me

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweets_of_me
  """
  @impl Behaviour
  defdelegate retweets_of_me, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/retweets_of_me

  ## Examples

      ExTwitter.retweets_of_me(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweets_of_me
  """
  @impl Behaviour
  defdelegate retweets_of_me(options), to: ExTwitter.API.Timelines

  # -------------- Tweets -------------

  @doc """
  GET statuses/retweets/:id

  ## Examples

      ExTwitter.retweets(444144169058308096)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweets/:id
  """
  @impl Behaviour
  defdelegate retweets(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/retweets/:id

  ## Examples

      ExTwitter.retweets(444144169058308096, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweets/:id
  """
  @impl Behaviour
  defdelegate retweets(id, options), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/show/:id

  ## Examples

      ExTwitter.show(446328507694845952)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/show/:id
  """
  @impl Behaviour
  defdelegate show(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/show/:id

  ## Examples

      ExTwitter.show(446328507694845952, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/show/:id
  """
  @impl Behaviour
  defdelegate show(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/destroy/:id

  ## Examples

      ExTwitter.destroy_status(446328507694845952)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/destroy/:id
  """
  @impl Behaviour
  defdelegate destroy_status(id), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/destroy/:id

  ## Examples

      ExTwitter.destroy_status(446328507694845952, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/destroy/:id
  """
  @impl Behaviour
  defdelegate destroy_status(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/update

  ## Examples

      ExTwitter.update("update sample")

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/update
  """
  @impl Behaviour
  defdelegate update(status), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/update

  ## Examples

      ExTwitter.update("update sample", trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/update
  """
  @impl Behaviour
  defdelegate update(status, options), to: ExTwitter.API.Tweets


  @doc """
  POST statuses/retweet/:id

  ## Examples

      ExTwitter.retweet(589095997340405760)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/retweet/:id
  """
  @impl Behaviour
  defdelegate retweet(id), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/retweet/:id

  ## Examples

      ExTwitter.retweet(589095997340405760, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/retweet/:id
  """
  @impl Behaviour
  defdelegate retweet(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/unretweet/:id

  ## Examples

      ExTwitter.unretweet(589095997340405760)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/unretweet/:id
  """
  @impl Behaviour
  defdelegate unretweet(id), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/unretweet/:id

  ## Examples

      ExTwitter.unretweet(589095997340405760, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/statuses/unretweet/:id
  """
  @impl Behaviour
  defdelegate unretweet(id, options), to: ExTwitter.API.Tweets


  @doc """
  POST media/upload
  POST statuses/update

  ## Examples

      image = File.read!("fixture/images/sample.png")
      ExTwitter.update_with_media("tweet with media", image)

  ## Reference
  https://dev.twitter.com/rest/reference/post/media/upload
  https://dev.twitter.com/rest/media/uploading-media

  ## Note
  This API works only for images at the moment.
  (Video files which requires chunked upload is not supported yet).
  """
  @impl Behaviour
  defdelegate update_with_media(status, media_content), to: ExTwitter.API.Tweets

  @doc """
  POST media/upload
  POST statuses/update

  ## Examples

      image = File.read!("fixture/images/sample.png")
      ExTwitter.update_with_media("tweet with media", image, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/media/upload
  https://dev.twitter.com/rest/media/uploading-media

  ## Note
  This API works only for images at the moment.
  (Video files which requires chunked upload is not supported yet).
  """
  @impl Behaviour
  defdelegate update_with_media(status, media_content, options), to: ExTwitter.API.Tweets

  @doc """
  POST upload.twitter.com/1.1/media/upload (INIT/APPEND/FINALIZE)
  POST statuses/update

  The default chunk size is 64kb (65,536 bytes). This can be adjusted via `update_with_chunked_media/4`.

  ## Examples

      ExTwitter.update_with_chunked_media("tweet with chunked media", "/path/to/file.mp4", "video/mp4")

  ## Reference
  https://developer.twitter.com/en/docs/media/upload-media/overview

  ## Note
  Unlike `update_with_media/3`, this supports the uploading of all Twitter-supported media types such as video files.
  """
  @impl Behaviour
  defdelegate update_with_chunked_media(status, path, content_type), to: ExTwitter.API.Tweets

  @doc """
  POST upload.twitter.com/1.1/media/upload (INIT/APPEND/FINALIZE)
  POST statuses/update

  Chunk size (in bytes) can be configured via the `:chunk_size` option. The default is 64kb (65,536 bytes).

  ## Examples

      ExTwitter.update_with_chunked_media("tweet with chunked media", "/path/to/file.mp4", "video/mp4", trim_user: true, chunk_size: 131_072)

  ## Reference
  https://developer.twitter.com/en/docs/media/upload-media/overview

  ## Note
  Unlike `update_with_media/3`, this supports the uploading of all Twitter-supported media types such as video files.
  """
  @impl Behaviour
  defdelegate update_with_chunked_media(status, path, content_type, options), to: ExTwitter.API.Tweets

  @doc """
    Chunk upload media and return media_id.
    POST media/upload (INIT)
    POST media/upload (APPEND)
    POST media/upload (FINALIZE)

    ## Examples
    media_id = upload_media("/tmp/image.png", "image/png") //chunk size defaults to 65536
    media_id = upload_media("/tmp/image.png", "image/png", 32768)
  """
  @impl Behaviour
  defdelegate upload_media(path, content_type), to: ExTwitter.API.Base

  @impl Behaviour
  defdelegate upload_media(path, content_type, chunk_size), to: ExTwitter.API.Base

  @doc """
  GET statuses/retweeters/ids

  ## Examples

      ExTwitter.retweeter_ids(444144169058308096)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweeters/ids
  """
  @impl Behaviour
  defdelegate retweeter_ids(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/retweeters/ids

  ## Examples

      ExTwitter.retweeter_ids(444144169058308096, stringify_ids: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/retweeters/ids
  """
  @impl Behaviour
  defdelegate retweeter_ids(id, options), to: ExTwitter.API.Tweets

  # -------------- Search -------------

  @doc """
  GET search/tweets

  ## Examples

      ExTwitter.search("test")

  ## Reference
  https://dev.twitter.com/rest/reference/get/search/tweets
  """
  @impl Behaviour
  defdelegate search(query), to: ExTwitter.API.Search

  @doc """
  GET search/tweets

  ## Examples

      ExTwitter.search("test", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/search/tweets
  """
  @impl Behaviour
  defdelegate search(query, options), to: ExTwitter.API.Search

  @doc """
  GET search/tweets

  ## Examples

      response = ExTwitter.search("pizza", [count: 100, search_metadata: true])
      ExTwitter.search_next_page(response.metadata)

  ## Reference
  https://dev.twitter.com/rest/reference/get/search/tweets
  """
  @impl Behaviour
  defdelegate search_next_page(search_result), to: ExTwitter.API.Search

  # -------------- Streaming -------------

  @doc """
  GET statuses/sample

  Returns a small random sample of all public statuses.
  This method returns the Stream that holds the list of tweets.

  ## Reference
  https://dev.twitter.com/streaming/reference/get/statuses/sample
  """
  @impl Behaviour
  defdelegate stream_sample, to: ExTwitter.API.Streaming

  @doc """
  GET user

  Returns timeline streaming for a user.
  This method returns the stream that holds the list of tweets.

  ## Examples

      ExTwitter.stream_user

  ## Reference
  https://dev.twitter.com/streaming/reference/get/user
  """
  @impl Behaviour
  defdelegate stream_user, to: ExTwitter.API.Streaming

  @impl Behaviour
  defdelegate stream_user(options), to: ExTwitter.API.Streaming

  @impl Behaviour
  defdelegate stream_user(options, timeout), to: ExTwitter.API.Streaming

  @doc """
  GET statuses/sample

  Returns a small random sample of all public statuses.
  This method returns the Stream that holds the list of tweets.

  ## Options

  The `options` can have following values, in addition to the
  twitter API's parameter.

    * `:receive_messages` - true/false flag whether to receive
    control messages in addition to normal tweets. default is false.

  ## Reference
  https://dev.twitter.com/streaming/reference/get/statuses/sample
  """
  @impl Behaviour
  defdelegate stream_sample(options), to: ExTwitter.API.Streaming

  @doc """
  POST statuses/filter

  Returns public statuses that match one or more filter predicates.
  This method returns the Stream that holds the list of tweets.
  Specify at least one of the [follow, track, locations] options.

  ## Options

  The `options` can have following values, in addition to the
  twitter API's parameter.

    * `:receive_messages` - true/false flag whether to receive
    control messages in addition to normal tweets. default is false.

  ## Examples

      ExTwitter.stream_filter(track: "apple")

  ## Reference
  https://dev.twitter.com/streaming/reference/post/statuses/filter
  """
  @impl Behaviour
  defdelegate stream_filter(options), to: ExTwitter.API.Streaming

  @doc """
  POST statuses/filter

  Returns public statuses that match one or more filter predicates.
  This method returns the Stream that holds the list of tweets.
  Specify at least one of the [follow, track, locations] options.

  ## Options

  The `options` can have following values, in addition to the
  twitter API's parameter.

    * `:receive_messages` - true/false flag whether to receive
    control messages in addition to normal tweets. default is false.

  The timeout is the maximum milliseconds to wait until receiving
  next tweet. Specifying `:infinity` makes it wait infinitely.

  ## Examples

      ExTwitter.stream_filter([track: "apple"], 60000)

  ## Reference
  https://dev.twitter.com/streaming/reference/post/statuses/filter
  """
  @impl Behaviour
  defdelegate stream_filter(options, timeout), to: ExTwitter.API.Streaming

  @doc """
  An interface to control the stream.

  This method is for controlling stream, and it doesn't make twitter API call.

  ## Options

  The `pid` is the process id where stream is being processed.

  ## Examples

      ExTwitter.stream_control(pid, :stop)
  """
  @impl Behaviour
  defdelegate stream_control(pid, stream_control_type), to: ExTwitter.API.Streaming

  @doc """
  An interface to control the stream.

  This method is for handling elixir's stream which can keep running infinitely.
  It doesn't make twitter API call.

  ## Options

  The `options` can have following values, in addition to the
  twitter API's parameter.

    * `:receive_messages` - true/false flag whether to receive
    control messages in addition to normal tweets. default is false.

  The `pid` is the process id where stream is processed.

  The `timeout` is the maximum wait time (in milliseconds) to complete
  the message handling.

  ## Examples

      ExTwitter.stream_control(pid, :stop, timeout: 50)
  """
  @impl Behaviour
  defdelegate stream_control(pid, stream_control_type, options), to: ExTwitter.API.Streaming

  # --------------  Direct Messages -------------

  @doc """
  GET direct_messages/show/:id

  ## Examples

      ExTwitter.direct_message(446328507694845952)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/show
  """
  @impl Behaviour
  defdelegate direct_message(id), to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages

  ## Examples

      ExTwitter.direct_messages

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages
  """
  @impl Behaviour
  defdelegate direct_messages, to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages

  ## Examples

      ExTwitter.direct_messages(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages
  """
  @impl Behaviour
  defdelegate direct_messages(options), to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages/sent

  ## Examples

      ExTwitter.sent_direct_messages

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/sent
  """
  @impl Behaviour
  defdelegate sent_direct_messages, to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages/sent

  ## Examples

      ExTwitter.sent_direct_messages(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/sent
  """
  @impl Behaviour
  defdelegate sent_direct_messages(options), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/new

  Specify one of the `screen name`, or `user id` in first argument.

  ## Examples

      ExTwitter.new_direct_message("twitter", "Message text")

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/new
  """
  @impl Behaviour
  defdelegate new_direct_message(id_or_screen_name, text), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/destroy/:id

  ## Examples

      ExTwitter.destroy_direct_message(12345)

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/destroy
  """
  @impl Behaviour
  defdelegate destroy_direct_message(id), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/destroy/:id

  ## Examples

      ExTwitter.destroy_direct_message(12345, include_entities: false)

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/destroy
  """
  @impl Behaviour
  defdelegate destroy_direct_message(id, options), to: ExTwitter.API.DirectMessages

  # -------------- Friends & Followers -------------

  # GET friendships/no_retweets/ids
  # https://dev.twitter.com/rest/reference/get/friendships/no_retweets/ids

  @doc """
  GET friends/ids

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.friend_ids("twitter")
      ExTwitter.friend_ids(783214)
      ExTwitter.friend_ids(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/friends/ids
  """
  @impl Behaviour
  defdelegate friend_ids(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/ids

  ## Examples

      ExTwitter.friend_ids("twitter", count: 1)
      ExTwitter.friend_ids(783214, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/friends/ids
  """
  @impl Behaviour
  defdelegate friend_ids(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/ids

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.follower_ids("twitter")
      ExTwitter.follower_ids(783214)
      ExTwitter.follower_ids(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/followers/ids
  """
  @impl Behaviour
  defdelegate follower_ids(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/ids

  ## Examples

      ExTwitter.follower_ids("twitter", count: 1)
      ExTwitter.follower_ids(783214, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/followers/ids
  """
  @impl Behaviour
  defdelegate follower_ids(id, options), to: ExTwitter.API.FriendsAndFollowers


  # GET friendships/incoming
  # https://dev.twitter.com/rest/reference/get/friendships/incoming

  # GET friendships/outgoing
  # https://dev.twitter.com/rest/reference/get/friendships/outgoing

  @doc """
  POST friendships/create

  ## Examples

      ExTwitter.follow("twitter")
      ExTwitter.follow(783214)

  ## Reference
  https://dev.twitter.com/rest/reference/post/friendships/create
  """
  @impl Behaviour
  defdelegate follow(id), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  POST friendships/create

  ## Examples

      ExTwitter.follow("twitter", follow: true)
      ExTwitter.follow(783214, follow: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/friendships/create
  """
  @impl Behaviour
  defdelegate follow(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  POST friendships/destroy

  ## Examples

      ExTwitter.unfollow("twitter")
      ExTwitter.unfollow(783214)

  ## Reference
  https://dev.twitter.com/rest/reference/post/friendships/destroy
  """
  @impl Behaviour
  defdelegate unfollow(id), to: ExTwitter.API.FriendsAndFollowers

  # POST friendships/update
  # https://dev.twitter.com/rest/reference/post/friendships/update

  # GET friendships/show
  # https://dev.twitter.com/rest/reference/get/friendships/show

  @doc """
  GET followers/list

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.followers("twitter")
      ExTwitter.followers(783214)
      ExTwitter.followers(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/followers/list
  """
  @impl Behaviour
  defdelegate followers(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/list

  ## Examples

      ExTwitter.followers("twitter", count: 1)
      ExTwitter.followers(783214, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/followers/list
  """
  @impl Behaviour
  defdelegate followers(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.friends("twitter")
      ExTwitter.friends(783214)
      ExTwitter.friends(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/friends/list
  """
  @impl Behaviour
  defdelegate friends(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list

  ## Examples

      ExTwitter.friends("twitter", count: 1)
      ExTwitter.friends(783214, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/friends/list
  """
  @impl Behaviour
  defdelegate friends(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friendships/lookup

  ## Examples

      ExTwitter.friends_lookup("twitter_support")

  ## Reference
  https://dev.twitter.com/rest/reference/get/friendships/lookup
  """
  @spec friends_lookup(String.t | Integer, Keyword.t) :: ExTwitter.Model.Relationship.t
  defdelegate friends_lookup(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friendships/lookup

  ## Examples

      ExTwitter.friends_lookup("twitter_support")

  ## Reference
  https://dev.twitter.com/rest/reference/get/friendships/lookup
  """
  @spec friends_lookup(String.t) :: ExTwitter.Model.Relationship.t
  defdelegate friends_lookup(id), to: ExTwitter.API.FriendsAndFollowers

  # -------------- Users -------------

  # GET account/settings
  # https://dev.twitter.com/rest/reference/get/account/settings

  @doc """
  GET account/verify_credentials

  ## Examples

      ExTwitter.verify_credentials
      ExTwitter.verify_credentials(include_email: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/account/verify_credentials
  """
  @impl Behaviour
  defdelegate verify_credentials, to: ExTwitter.API.Users

  @impl Behaviour
  defdelegate verify_credentials(options), to: ExTwitter.API.Users


  # POST account/settings
  # https://dev.twitter.com/rest/reference/post/account/settings

  # POST account/update_profile
  # https://dev.twitter.com/rest/reference/post/account/update_profile

  # POST account/update_profile_background_image
  # https://dev.twitter.com/rest/reference/post/account/update_profile_background_image

  # POST account/update_profile_image
  # https://dev.twitter.com/rest/reference/post/account/update_profile_image

  # GET blocks/list
  # https://dev.twitter.com/rest/reference/get/blocks/list

  # GET blocks/ids
  # https://dev.twitter.com/rest/reference/get/blocks/ids

  @doc """
  POST blocks/create

  ## Examples

      ExTwitter.block("twitter")
      ExTwitter.block(783214)

  ## Reference
  https://dev.twitter.com/rest/reference/post/blocks/create
  """
  @impl Behaviour
  defdelegate block(id), to: ExTwitter.API.Blocks

  @doc """
  POST blocks/destroy

  ## Examples

      ExTwitter.unblock("twitter")
      ExTwitter.unblock(783214)

  ## Reference
  https://dev.twitter.com/rest/reference/post/blocks/destroy
  """
  @impl Behaviour
  defdelegate unblock(id), to: ExTwitter.API.Blocks

  @doc """
  GET users/lookup

  ## Examples

      ExTwitter.user_lookup("twitter")
      ExTwitter.user_lookup(783214)
      ExTwitter.user_lookup(screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/lookup
  """
  @impl Behaviour
  defdelegate user_lookup(id_or_options), to: ExTwitter.API.Users

  @doc """
  GET users/lookup

  ## Examples

      ExTwitter.user_lookup("twitter", include_entities: false)
      ExTwitter.user_lookup(783214, include_entities: false)
      ExTwitter.user_lookup(["twitter", "josevalim"], include_entities: false)
      ExTwitter.user_lookup([783214, 10230812], include_entities: false)

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/lookup
  """
  @impl Behaviour
  defdelegate user_lookup(id_or_screen_name_list, options), to: ExTwitter.API.Users

  @doc """
  GET users/profile_banner

  ## Examples

      ExTwitter.user_profile_banner(783214)
      ExTwitter.user_profile_banner("twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/profile_banner
  """
  @impl Behaviour
  defdelegate user_profile_banner(id_or_screen_name), to: ExTwitter.API.Users


  @doc """
  GET users/show

  ## Examples

      ExTwitter.user("elixirlang")
      ExTwitter.user(507309896)

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/show
  """
  @impl Behaviour
  defdelegate user(id_or_screen_name), to: ExTwitter.API.Users

  @doc """
  GET users/show

  ## Examples

      ExTwitter.user("elixirlang", include_entities: false)
      ExTwitter.user(507309896, include_entities: false)

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/show
  """
  @impl Behaviour
  defdelegate user(id_or_screen_name, options), to: ExTwitter.API.Users

  # TODO: deprecated method
  @doc false
  defdelegate user(user_id, screen_name, options), to: ExTwitter.API.Users

  @doc """
  GET users/search

  ## Examples

      ExTwitter.user_search("elixirlang")

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/search
  """
  @impl Behaviour
  defdelegate user_search(query), to: ExTwitter.API.Users

  @doc """
  GET users/search

  ## Examples

      ExTwitter.user_search("elixirlang", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/users/search
  """
  @impl Behaviour
  defdelegate user_search(query, options), to: ExTwitter.API.Users

  # POST account/remove_profile_banner
  # https://dev.twitter.com/rest/reference/post/account/remove_profile_banner

  # POST account/update_profile_banner
  # https://dev.twitter.com/rest/reference/post/account/update_profile_banner

  # POST mutes/users/create
  # https://dev.twitter.com/rest/reference/post/mutes/users/create

  # POST mutes/users/destroy
  # https://dev.twitter.com/rest/reference/post/mutes/users/destroy

  # GET mutes/users/ids
  # https://dev.twitter.com/rest/reference/get/mutes/users/ids

  # GET mutes/users/list
  # https://dev.twitter.com/rest/reference/get/mutes/users/list

  # -------------- Suggested Users -------------

  # GET users/suggestions/:slug
  # https://dev.twitter.com/rest/reference/get/users/suggestions/:slug

  # GET users/suggestions
  # https://dev.twitter.com/rest/reference/get/users/suggestions

  # GET users/suggestions/:slug/members
  # https://dev.twitter.com/rest/reference/get/users/suggestions/:slug/members

  # -------------- Favorites -------------

  @doc """
  GET favorites/list

  ## Reference
  https://dev.twitter.com/rest/reference/get/favorites/list
  """
  @impl Behaviour
  defdelegate favorites, to: ExTwitter.API.Favorites

  @doc """
  GET favorites/list

  ## Examples

      ExTwitter.favorites(screen_name: "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/favorites/list
  """
  @impl Behaviour
  defdelegate favorites(options), to: ExTwitter.API.Favorites

  @doc """
  POST favorites/create

  ## Reference
  https://dev.twitter.com/rest/reference/post/favorites/create
  """
  @impl Behaviour
  defdelegate create_favorite(id, options), to: ExTwitter.API.Favorites

  @doc """
  POST favorites/destroy

  ## Reference
  https://dev.twitter.com/rest/reference/post/favorites/destroy
  """
  @impl Behaviour
  defdelegate destroy_favorite(id, options), to: ExTwitter.API.Favorites

  # -------------- Lists -------------

  @doc """
  POST lists/create

    ## Examples

    ExTwitter.create_list("new list")
    ExTwitter.create_list([name: "new list"])

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/list
  """
  @impl Behaviour
  defdelegate create_list(list_name), to: ExTwitter.API.Lists

  @doc """
  GET lists/list

  ## Examples

      ExTwitter.lists("twitter")
      ExTwitter.lists(783214)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/list
  """
  @impl Behaviour
  defdelegate lists(id_or_screen_name), to: ExTwitter.API.Lists

  @doc """
  GET lists/list

  ## Examples

      ExTwitter.lists("twitter", count: 1)
      ExTwitter.lists(783214, count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/list
  """
  @impl Behaviour
  defdelegate lists(id_or_screen_name, options), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/statuses
  """
  @impl Behaviour
  defdelegate list_timeline(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/statuses
  """
  @impl Behaviour
  defdelegate list_timeline(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/statuses
  """
  @impl Behaviour
  defdelegate list_timeline(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/members/destroy
  # https://dev.twitter.com/rest/reference/post/lists/members/destroy

  @doc """
  GET lists/memberships

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/memberships
  """
  @impl Behaviour
  defdelegate list_memberships, to: ExTwitter.API.Lists

  # POST lists/members/destroy
  # https://dev.twitter.com/rest/reference/post/lists/members/destroy

  @doc """
  GET lists/memberships

  ## Examples

      ExTwitter.list_memberships(screen_name: "twitter", count: 2)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/memberships
  """
  @impl Behaviour
  defdelegate list_memberships(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/subscribers
  """
  @impl Behaviour
  defdelegate list_subscribers(options),              to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/subscribers
  """
  @impl Behaviour
  defdelegate list_subscribers(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/subscribers
  """
  @impl Behaviour
  defdelegate list_subscribers(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/subscribers/create
  # https://dev.twitter.com/rest/reference/post/lists/subscribers/create

  # GET lists/subscribers/show
  # https://dev.twitter.com/rest/reference/get/lists/subscribers/show

  # POST lists/subscribers/destroy
  # https://dev.twitter.com/rest/reference/post/lists/subscribers/destroy

  # POST lists/members/create_all
  # https://dev.twitter.com/rest/reference/post/lists/members/create_all

  # GET lists/members/show
  # https://dev.twitter.com/rest/reference/get/lists/members/show

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/members
  """
  @impl Behaviour
  defdelegate list_members(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/members
  """
  @impl Behaviour
  defdelegate list_members(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/lists/members
  """
  @impl Behaviour
  defdelegate list_members(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/members/create
  # https://dev.twitter.com/rest/reference/post/lists/members/create

  # POST lists/destroy
  # https://dev.twitter.com/rest/reference/post/lists/destroy

  # POST lists/update
  # https://dev.twitter.com/rest/reference/post/lists/update

  # POST lists/create
  # https://dev.twitter.com/rest/reference/post/lists/create

  # GET lists/show
  # https://dev.twitter.com/rest/reference/get/lists/show

  # GET lists/subscriptions
  # https://dev.twitter.com/rest/reference/get/lists/subscriptions

  # POST lists/members/destroy_all
  # https://dev.twitter.com/rest/reference/post/lists/members/destroy_all

  # GET lists/ownerships
  # https://dev.twitter.com/rest/reference/get/lists/ownerships

  # -------------- Saved Searches -------------

  # -------------- Places & Geo -------------

  # GET geo/id/:place_id
  # https://dev.twitter.com/rest/reference/get/geo/id/:place_id

  @doc """
  GET geo/reverse_geocode

  ## Examples

      ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116)

  ## Reference
  https://dev.twitter.com/rest/reference/get/geo/reverse_geocode
  """
  @impl Behaviour
  defdelegate reverse_geocode(lat, long), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/reverse_geocode

  ## Examples

      ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116, max_results: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/geo/reverse_geocode
  """
  @impl Behaviour
  defdelegate reverse_geocode(lat, long, options), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/search

  ## Examples

      ExTwitter.geo_search("new york")

  ## Reference
  https://dev.twitter.com/rest/reference/get/geo/search
  """
  @impl Behaviour
  defdelegate geo_search(query), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/search

  ## Examples

      ExTwitter.geo_search("new york", max_results: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/geo/search
  """
  @impl Behaviour
  defdelegate geo_search(query, options), to: ExTwitter.API.PlacesAndGeo

  # POST geo/place
  # https://dev.twitter.com/rest/reference/post/geo/place

  # -------------- Trends -------------

  @doc """
  GET trends/place

  ## Examples

      ExTwitter.trends(1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/trends/place
  """
  @impl Behaviour
  defdelegate trends(id), to: ExTwitter.API.Trends

  @doc """
  GET trends/place

  ## Examples

      ExTwitter.trends(1, exclude: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/trends/place
  """
  @impl Behaviour
  defdelegate trends(id, options), to: ExTwitter.API.Trends

  # GET trends/available
  # https://dev.twitter.com/rest/reference/get/trends/available

  # GET trends/closest
  # https://dev.twitter.com/rest/reference/get/trends/closest

  # -------------- Spam Reporting -------------

  # -------------- OAuth -------------

  # -------------- Help -------------

  # GET help/configuration
  # https://dev.twitter.com/rest/reference/get/help/configuration

  # GET help/languages
  # https://dev.twitter.com/rest/reference/get/help/languages

  # GET help/privacy
  # https://dev.twitter.com/rest/reference/get/help/privacy

  # GET help/tos
  # https://dev.twitter.com/rest/reference/get/help/tos

  @doc """
  GET application/rate_limit_status

  ## Examples

      status = ExTwitter.rate_limit_status
      limit = status["resources"]["statuses"]["/statuses/home_timeline"]["remaining"]

  ## Reference
  https://dev.twitter.com/rest/reference/get/application/rate_limit_status
  """
  @impl Behaviour
  defdelegate rate_limit_status, to: ExTwitter.API.Help

  @doc """
  GET application/rate_limit_status

  ## Examples

      ExTwitter.rate_limit_status(resources: "statuses")

  ## Reference
  https://dev.twitter.com/rest/reference/get/application/rate_limit_status
  """
  @impl Behaviour
  defdelegate rate_limit_status(options), to: ExTwitter.API.Help

  # -------------- Tweets -------------

  @doc """
  GET statuses/lookup

  ## Examples

      ExTwitter.lookup_status("504692034473435136,502883389347622912")

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/lookup
  """
  @impl Behaviour
  defdelegate lookup_status(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/lookup

  ## Examples

      ExTwitter.lookup_status("504692034473435136,502883389347622912", trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/statuses/lookup
  """
  @impl Behaviour
  defdelegate lookup_status(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST oauth/request_token

  ## Examples

      ExTwitter.request_token("http://myapp.com/twitter-callback")

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/request_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate request_token(redirect_url), to: ExTwitter.API.Auth

  @doc """
  POST oauth/request_token

  ## Examples

      ExTwitter.request_token

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/request_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate request_token, to: ExTwitter.API.Auth

  @doc """
  GET oauth/authorize
  Returns the URL you should redirect the user to for 3-legged authorization

  ## Examples

      token = ExTwitter.request_token
      ExTwitter.authorize_url(token.oauth_token, %{force_login: true})

  ## Reference
  https://dev.twitter.com/oauth/reference/get/oauth/authorize
  https://dev.twitter.com/oauth/3-legged
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate authorize_url(oauth_token, options), to: ExTwitter.API.Auth

  @doc """
  GET oauth/authorize

  ## Examples

      token = ExTwitter.request_token
      ExTwitter.authorize_url(token.oauth_token)

  Returns the URL you should redirect the user to for 3-legged authorization
  """
  @impl Behaviour
  defdelegate authorize_url(oauth_token), to: ExTwitter.API.Auth

  @doc """
  GET oauth/authenticate
  Returns the URL you should redirect the user to for twitter sign-in

  ## Examples

      token = ExTwitter.request_token
      ExTwitter.authenticate_url(token.oauth_token, %{force_login: true})

  ## Reference
  https://dev.twitter.com/oauth/reference/get/oauth/authenticate
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate authenticate_url(oauth_token, options), to: ExTwitter.API.Auth

  @doc """
  GET oauth/authenticate
  Returns the URL you should redirect the user to for twitter sign-in

  ## Examples

      token = ExTwitter.request_token
      ExTwitter.authenticate_url(token.oauth_token)

  ## Reference
  https://dev.twitter.com/oauth/reference/get/oauth/authenticate
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate authenticate_url(oauth_token), to: ExTwitter.API.Auth

  @doc """
  POST oauth/access_token

  ## Examples

      ExTwitter.access_token("OAUTH_VERIFIER", "ACCESS_TOKEN", "ACCESS_TOKEN_SECRET")

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/access_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @impl Behaviour
  defdelegate access_token(verifier, request_token), to: ExTwitter.API.Auth
end
