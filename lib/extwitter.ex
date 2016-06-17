defmodule ExTwitter do
  @moduledoc """
  Provides access interfaces for the Twitter API.
  """

  use Application

  @doc false
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
  @spec configure(Keyword.t) :: :ok
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
  @spec configure(:global | :process, Keyword.t) :: :ok
  defdelegate configure(scope, oauth), to: ExTwitter.Config, as: :set

  @doc """
  Returns current OAuth configuration settings for accessing twitter server.
  """
  @spec configure :: Keyword.t | nil
  defdelegate configure, to: ExTwitter.Config, as: :get

  @doc """
  Provides general twitter API access interface.

  This method simply returns parsed json in Map structure.

  ## Examples

      ExTwitter.request(:get, "1.1/statuses/home_timeline.json")

  """
  @spec request(:get | :post, String.t) :: Map
  defdelegate request(method, path), to: ExTwitter.API.Base

  @doc """
  Provides general twitter API access interface.

  This method simply returns parsed json in Map structure.

  ## Examples

      ExTwitter.request(:get, "1.1/search/tweets.json", [q: "elixir", count: 1])

  """
  @spec request(:get | :post, String.t, Keyword.t) :: Map
  defdelegate request(method, path, params), to: ExTwitter.API.Base

  # -------------- Timelines -------------

  @doc """
  GET statuses/mentions_timeline

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/mentions_timeline
  """
  @spec mentions_timeline :: [ExTwitter.Model.Tweet.t]
  defdelegate mentions_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/mentions_timeline

  ## Examples

      ExTwitter.mentions_timeline(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/mentions_timeline
  """
  @spec mentions_timeline(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate mentions_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/user_timeline

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
  """
  @spec user_timeline :: [ExTwitter.Model.Tweet.t]
  defdelegate user_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/user_timeline

  ## Examples

      ExTwitter.user_timeline(count: 1)
      ExTwitter.user_timeline([screen_name: "josevalim", count: 12])

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
  """
  @spec user_timeline(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate user_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/home_timeline

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
  """
  @spec home_timeline :: [ExTwitter.Model.Tweet.t]
  defdelegate home_timeline, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/home_timeline

  ## Examples

      ExTwitter.home_timeline(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
  """
  @spec home_timeline(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate home_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/retweets_of_me

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets_of_me
  """
  @spec retweets_of_me :: [ExTwitter.Model.Tweet.t]
  defdelegate retweets_of_me, to: ExTwitter.API.Timelines

  @doc """
  GET statuses/retweets_of_me

  ## Examples

      ExTwitter.retweets_of_me(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets_of_me
  """
  @spec retweets_of_me(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate retweets_of_me(options), to: ExTwitter.API.Timelines

  # -------------- Tweets -------------

  @doc """
  GET statuses/retweets/:id

  ## Examples

      ExTwitter.retweets(444144169058308096)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/%3Aid
  """
  @spec retweets(Integer | String.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate retweets(id),          to: ExTwitter.API.Tweets

  @doc """
  GET statuses/retweets/:id

  ## Examples

      ExTwitter.retweets(444144169058308096, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/%3Aid
  """
  @spec retweets(Integer | String.t, Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate retweets(id, options), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/show/:id

  ## Examples

      ExTwitter.show(446328507694845952)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
  """
  @spec show(Integer | String.t) :: ExTwitter.Model.Tweet.t
  defdelegate show(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/show/:id

  ## Examples

      ExTwitter.show(446328507694845952, trim_user: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
  """
  @spec show(Integer | String.t, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate show(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/destroy/:id

  ## Examples

      ExTwitter.destroy_status(446328507694845952)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/%3Aid
  """
  @spec destroy_status(Integer) :: ExTwitter.Model.Tweet.t
  defdelegate destroy_status(id), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/destroy/:id

  ## Examples

      ExTwitter.destroy_status(446328507694845952, trim_user: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/%3Aid
  """
  @spec destroy_status(Integer, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate destroy_status(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/update

  ## Examples

      ExTwitter.update("update sample")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/update
  """
  @spec update(String.t) :: ExTwitter.Model.Tweet.t
  defdelegate update(status), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/update

  ## Examples

      ExTwitter.update("update sample", trim_user: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/update
  """
  @spec update(String.t, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate update(status, options), to: ExTwitter.API.Tweets


  @doc """
  POST statuses/retweet/:id

  ## Examples

      ExTwitter.retweet(589095997340405760)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/%3Aid
  """
  @spec retweet(Integer) :: ExTwitter.Model.Tweet.t
  defdelegate retweet(id), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/retweet/:id

  ## Examples

      ExTwitter.retweet(589095997340405760, trim_user: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/%3Aid
  """
  @spec retweet(Integer, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate retweet(id, options), to: ExTwitter.API.Tweets


  @doc """
  POST media/upload
  POST statuses/update

  ## Examples

      image = File.read!("fixture/images/sample.png")
      ExTwitter.update_with_media("tweet with media", image)

  ## Reference
  https://dev.twitter.com/rest/reference/post/media/upload
  https://dev.twitter.com/rest/public/uploading-media

  ## Note
  This API works only for images at the moment.
  (Video files which requires chunked upload is not supported yet).
  """
  @spec update_with_media(String.t, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate update_with_media(status, media_content), to: ExTwitter.API.Tweets

  @doc """
  POST media/upload
  POST statuses/update

  ## Examples

      image = File.read!("fixture/images/sample.png")
      ExTwitter.update_with_media("tweet with media", image, trim_user: true)

  ## Reference
  https://dev.twitter.com/rest/reference/post/media/upload
  https://dev.twitter.com/rest/public/uploading-media

  ## Note
  This API works only for images at the moment.
  (Video files which requires chunked upload is not supported yet).
  """
  @spec update_with_media(String.t, String.t, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate update_with_media(status, media_content, options), to: ExTwitter.API.Tweets

  # GET statuses/oembed
  # https://dev.twitter.com/docs/api/1.1/get/statuses/oembed

  @doc """
  GET statuses/retweeters/ids

  ## Examples

      ExTwitter.retweeter_ids(444144169058308096)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
  """
  @spec retweeter_ids(Integer | String.t) :: [Integer | String.t]
  defdelegate retweeter_ids(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/retweeters/ids

  ## Examples

      ExTwitter.retweeter_ids(444144169058308096, stringify_ids: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
  """
  @spec retweeter_ids(Integer | String.t, Keyword.t) :: [Integer | String.t]
  defdelegate retweeter_ids(id, options), to: ExTwitter.API.Tweets

  # -------------- Search -------------

  @doc """
  GET search/tweets

  ## Examples

      ExTwitter.search("test")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/search/tweets
  """
  @spec search(String.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate search(query), to: ExTwitter.API.Search

  @doc """
  GET search/tweets

  ## Examples

      ExTwitter.search("test", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/search/tweets
  """
  @spec search(String.t, Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate search(query, options), to: ExTwitter.API.Search

  # -------------- Streaming -------------

  @doc """
  GET statuses/sample

  Returns a small random sample of all public statuses.
  This method returns the Stream that holds the list of tweets.

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/sample
  """
  @spec stream_sample :: Enumerable.t
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
  @spec stream_user :: Enumerable.t
  defdelegate stream_user, to: ExTwitter.API.Streaming

  @spec stream_user(Keyword.t) :: Enumerable.t
  defdelegate stream_user(options), to: ExTwitter.API.Streaming

  @spec stream_user(Keyword.t, Integer) :: Enumerable.t
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
  https://dev.twitter.com/docs/api/1.1/get/statuses/sample
  """
  @spec stream_sample(Keyword.t) :: Enumerable.t
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
  https://dev.twitter.com/docs/api/1.1/post/statuses/filter
  """
  @spec stream_filter(Keyword.t) :: Enumerable.t
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

      ExTwitter.stream_filter(track: "apple", timeout: 60000)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/statuses/filter
  """
  @spec stream_filter(Keyword.t, [timeout: Integer]) :: Enumerable.t
  defdelegate stream_filter(options, timeout), to: ExTwitter.API.Streaming

  @doc """
  An interface to control the stream.

  This method is for controlling stream, and it doesn't make twitter API call.

  ## Options

  The `pid` is the process id where stream is being processed.

  ## Examples

      ExTwitter.stream_control(pid, :stop)
  """
  @type stream_control_type :: :stop
  @spec stream_control(pid, stream_control_type) :: :ok
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
  @spec stream_control(pid, stream_control_type, [timeout: Integer]) :: :ok
  defdelegate stream_control(pid, stream_control_type, options), to: ExTwitter.API.Streaming

  # --------------  Direct Messages -------------

  @doc """
  GET direct_messages/show/:id

  ## Examples

      ExTwitter.direct_message(446328507694845952)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/show
  """
  @spec direct_message(Integer | String.t) :: ExTwitter.Model.DirectMessage.t
  defdelegate direct_message(id), to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages

  ## Examples

      ExTwitter.direct_messages

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages
  """
  @spec direct_messages :: [ExTwitter.Model.DirectMessage.t]
  defdelegate direct_messages, to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages

  ## Examples

      ExTwitter.direct_messages(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages
  """
  @spec direct_messages(Keyword.t) :: [ExTwitter.Model.DirectMessage.t]
  defdelegate direct_messages(options), to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages/sent

  ## Examples

      ExTwitter.sent_direct_messages

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/sent
  """
  @spec sent_direct_messages :: [ExTwitter.Model.DirectMessage.t]
  defdelegate sent_direct_messages, to: ExTwitter.API.DirectMessages

  @doc """
  GET direct_messages/sent

  ## Examples

      ExTwitter.sent_direct_messages(count: 1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/direct_messages/sent
  """
  @spec sent_direct_messages(Keyword.t) :: [ExTwitter.Model.DirectMessage.t]
  defdelegate sent_direct_messages(options), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/new

  Specify one of the `screen name`, or `user id` in first argument.

  ## Examples

      ExTwitter.new_direct_message("twitter", "Message text")

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/new
  """
  @spec new_direct_message(String.t | Integer, String.t) :: ExTwitter.Model.DirectMessage.t
  defdelegate new_direct_message(id_or_screen_name, text), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/destroy/:id

  ## Examples

      ExTwitter.destroy_direct_message(12345)

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/destroy
  """
  @spec destroy_direct_message(Integer) :: ExTwitter.Model.DirectMessage.t
  defdelegate destroy_direct_message(id), to: ExTwitter.API.DirectMessages

  @doc """
  POST direct_messages/destroy/:id

  ## Examples

      ExTwitter.destroy_direct_message(12345, include_entities: false)

  ## Reference
  https://dev.twitter.com/rest/reference/post/direct_messages/destroy
  """
  @spec destroy_direct_message(Integer, Keyword.t) :: ExTwitter.Model.DirectMessage.t
  defdelegate destroy_direct_message(id, options), to: ExTwitter.API.DirectMessages

  # -------------- Friends & Followers -------------

  # GET friendships/no_retweets/ids
  # https://dev.twitter.com/docs/api/1.1/get/friendships/no_retweets/ids

  @doc """
  GET friends/ids

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.friend_ids("twitter")
      ExTwitter.friend_ids(783214)
      ExTwitter.friend_ids(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/friends/ids
  """
  @spec friend_ids(String.t | Integer | Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate friend_ids(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/ids

  ## Examples

      ExTwitter.friend_ids("twitter", count: 1)
      ExTwitter.friend_ids(783214, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/friends/ids
  """
  @spec friend_ids(String.t | Integer, Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate friend_ids(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/ids

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.follower_ids("twitter")
      ExTwitter.follower_ids(783214)
      ExTwitter.follower_ids(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/followers/ids
  """
  @spec follower_ids(String.t | Integer | Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate follower_ids(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/ids

  ## Examples

      ExTwitter.follower_ids("twitter", count: 1)
      ExTwitter.follower_ids(783214, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/followers/ids
  """
  @spec follower_ids(String.t | Integer, Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate follower_ids(id, options), to: ExTwitter.API.FriendsAndFollowers


  # GET friendships/incoming
  # https://dev.twitter.com/docs/api/1.1/get/friendships/incoming

  # GET friendships/outgoing
  # https://dev.twitter.com/docs/api/1.1/get/friendships/outgoing

  @doc """
  POST friendships/create

  ## Examples

      ExTwitter.follow("twitter")
      ExTwitter.follow(783214)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/friendships/create
  """
  @spec follow(String.t | Integer) :: ExTwitter.Model.User.t
  defdelegate follow(id), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  POST friendships/create

  ## Examples

      ExTwitter.follow("twitter", follow: true)
      ExTwitter.follow(783214, follow: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/friendships/create
  """
  @spec follow(String.t | Integer, Keyword.t) :: ExTwitter.Model.User.t
  defdelegate follow(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  POST friendships/destroy

  ## Examples

      ExTwitter.unfollow("twitter")
      ExTwitter.unfollow(783214)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/friendships/destroy
  """
  @spec unfollow(String.t | Integer) :: ExTwitter.Model.User.t
  defdelegate unfollow(id), to: ExTwitter.API.FriendsAndFollowers

  # POST friendships/update
  # https://dev.twitter.com/docs/api/1.1/post/friendships/update

  # GET friendships/show
  # https://dev.twitter.com/docs/api/1.1/get/friendships/show

  @doc """
  GET followers/list

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.followers("twitter")
      ExTwitter.followers(783214)
      ExTwitter.followers(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/followers/list
  """
  @spec followers(String.t | Integer | Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate followers(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET followers/list

  ## Examples

      ExTwitter.followers("twitter", count: 1)
      ExTwitter.followers(783214, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/followers/list
  """
  @spec followers(String.t | Integer, Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate followers(id, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list

  Specify one of the `screen_name`, `user_id` or `options` in the argument.

  ## Examples

      ExTwitter.friends("twitter")
      ExTwitter.friends(783214)
      ExTwitter.friends(count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/friends/list
  """
  @spec friends(String.t | Integer | Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate friends(id_or_options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list

  ## Examples

      ExTwitter.friends("twitter", count: 1)
      ExTwitter.friends(783214, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/friends/list
  """
  @spec friends(String.t | Integer, Keyword.t) :: ExTwitter.Model.Cursor.t
  defdelegate friends(id, options), to: ExTwitter.API.FriendsAndFollowers

  # GET friendships/lookup
  # https://dev.twitter.com/docs/api/1.1/get/friendships/lookup

  # -------------- Users -------------

  # GET account/settings
  # https://dev.twitter.com/docs/api/1.1/get/account/settings

  @doc """
  GET account/verify_credentials

  ## Examples

      ExTwitter.verify_credentials
      ExTwitter.verify_credentials(include_email: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials
  """
  @spec verify_credentials :: ExTwitter.Model.User.t
  defdelegate verify_credentials, to: ExTwitter.API.Users


  # POST account/settings
  # https://dev.twitter.com/docs/api/1.1/post/account/settings

  # POST account/update_delivery_device
  # https://dev.twitter.com/docs/api/1.1/post/account/update_delivery_device

  # POST account/update_profile
  # https://dev.twitter.com/docs/api/1.1/post/account/update_profile

  # POST account/update_profile_background_image
  # https://dev.twitter.com/docs/api/1.1/post/account/update_profile_background_image

  # POST account/update_profile_colors
  # https://dev.twitter.com/docs/api/1.1/post/account/update_profile_colors

  # POST account/update_profile_image
  # https://dev.twitter.com/docs/api/1.1/post/account/update_profile_image

  # GET blocks/list
  # https://dev.twitter.com/docs/api/1.1/get/blocks/list

  # GET blocks/ids
  # https://dev.twitter.com/docs/api/1.1/get/blocks/ids

  # POST blocks/create
  # https://dev.twitter.com/docs/api/1.1/post/blocks/create

  # POST blocks/destroy
  # https://dev.twitter.com/docs/api/1.1/post/blocks/destroy

  @doc """
  GET users/lookup

  ## Examples

      ExTwitter.user_lookup("twitter")
      ExTwitter.user_lookup(783214)
      ExTwitter.user_lookup(screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/lookup
  """
  @spec user_lookup(String.t | Integer | Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate user_lookup(id_or_options), to: ExTwitter.API.Users

  @doc """
  GET users/lookup

  ## Examples

      ExTwitter.user_lookup("twitter", include_entities: false)
      ExTwitter.user_lookup(783214, include_entities: false)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/lookup
  """
  @spec user_lookup(String.t | Integer, Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate user_lookup(screen_name, options), to: ExTwitter.API.Users

  @doc """
  GET users/show

  ## Examples

      ExTwitter.user("elixirlang")
      ExTwitter.user(507309896)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/show
  """
  @spec user(String.t | Integer) :: ExTwitter.Model.User.t
  defdelegate user(id_or_screen_name), to: ExTwitter.API.Users

  @doc """
  GET users/show

  ## Examples

      ExTwitter.user("elixirlang", include_entities: false)
      ExTwitter.user(507309896, include_entities: false)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/show
  """
  @spec user(String.t | Integer, Keyword.t) :: ExTwitter.Model.User.t
  defdelegate user(id_or_screen_name, options), to: ExTwitter.API.Users

  # TODO: deprecated method
  @doc false
  defdelegate user(user_id, screen_name, options), to: ExTwitter.API.Users

  @doc """
  GET users/search

  ## Examples

      ExTwitter.user_search("elixirlang")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/search
  """
  @spec user_search(String.t) :: [ExTwitter.Model.User.t]
  defdelegate user_search(query), to: ExTwitter.API.Users

  @doc """
  GET users/search

  ## Examples

      ExTwitter.user_search("elixirlang", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/users/search
  """
  @spec user_search(String.t, Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate user_search(query, options), to: ExTwitter.API.Users

  # GET users/contributees
  # https://dev.twitter.com/docs/api/1.1/get/users/contributees

  # GET users/contributors
  # https://dev.twitter.com/docs/api/1.1/get/users/contributors

  # POST account/remove_profile_banner
  # https://dev.twitter.com/docs/api/1.1/post/account/remove_profile_banner

  # POST account/update_profile_banner
  # https://dev.twitter.com/docs/api/1.1/post/account/update_profile_banner

  # POST mutes/users/create
  # https://dev.twitter.com/docs/api/1.1/post/mutes/users/create

  # POST mutes/users/destroy
  # https://dev.twitter.com/docs/api/1.1/post/mutes/users/destroy

  # GET mutes/users/ids
  # https://dev.twitter.com/docs/api/1.1/get/mutes/users/ids

  # GET mutes/users/list
  # https://dev.twitter.com/docs/api/1.1/get/mutes/users/list

  # -------------- Suggested Users -------------

  # GET users/suggestions/:slug
  # https://dev.twitter.com/docs/api/1.1/get/users/suggestions/%3Aslug

  # GET users/suggestions
  # https://dev.twitter.com/docs/api/1.1/get/users/suggestions

  # GET users/suggestions/:slug/members
  # https://dev.twitter.com/docs/api/1.1/get/users/suggestions/%3Aslug/members

  # -------------- Favorites -------------

  @doc """
  GET favorites/list

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/favorites/list
  """
  @spec favorites :: [ExTwitter.Model.Tweet.t]
  defdelegate favorites, to: ExTwitter.API.Favorites

  @doc """
  GET favorites/list

  ## Examples

      ExTwitter.favorites(screen_name: "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/favorites/list
  """
  @spec favorites(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate favorites(options), to: ExTwitter.API.Favorites

  @doc """
  POST favorites/create

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/favorites/create
  """
  @spec create_favorite(Integer, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate create_favorite(id, options), to: ExTwitter.API.Favorites

  @doc """
  POST favorites/destroy

  ## Reference
  https://dev.twitter.com/docs/api/1.1/post/favorites/destroy
  """
  @spec destroy_favorite(Integer, Keyword.t) :: ExTwitter.Model.Tweet.t
  defdelegate destroy_favorite(id, options), to: ExTwitter.API.Favorites

  # -------------- Lists -------------

  @doc """
  GET lists/list

  ## Examples

      ExTwitter.lists("twitter")
      ExTwitter.lists(783214)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/list
  """
  @spec lists(String.t | Integer) :: [ExTwitter.Model.List.t]
  defdelegate lists(id_or_screen_name), to: ExTwitter.API.Lists

  @doc """
  GET lists/list

  ## Examples

      ExTwitter.lists("twitter", count: 1)
      ExTwitter.lists(783214, count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/list
  """
  @spec lists(String.t | Integer, Keyword.t) :: [ExTwitter.Model.List.t]
  defdelegate lists(id_or_screen_name, options), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/statuses
  """
  @spec list_timeline(Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate list_timeline(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/statuses
  """
  @spec list_timeline(String.t, String.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate list_timeline(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses

  ## Examples

      ExTwitter.list_timeline("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/statuses
  """
  @spec list_timeline(String.t, String.t, Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate list_timeline(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/members/destroy
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy

  @doc """
  GET lists/memberships

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/memberships
  """
  @spec list_memberships :: [ExTwitter.Model.List.t]
  defdelegate list_memberships, to: ExTwitter.API.Lists

  # POST lists/members/destroy
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy

  @doc """
  GET lists/memberships

  ## Examples

      ExTwitter.list_memberships(screen_name: "twitter", count: 2)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/memberships
  """
  @spec list_memberships(Keyword.t) :: [ExTwitter.Model.List.t]
  defdelegate list_memberships(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
  """
  @spec list_subscribers(Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate list_subscribers(options),              to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
  """
  @spec list_subscribers(String.t, String.t) :: [ExTwitter.Model.User.t]
  defdelegate list_subscribers(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers

  ## Examples

      ExTwitter.list_subscribers("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
  """
  @spec list_subscribers(String.t, String.t, Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate list_subscribers(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/subscribers/create
  # https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/create

  # GET lists/subscribers/show
  # https://dev.twitter.com/docs/api/1.1/get/lists/subscribers/show

  # POST lists/subscribers/destroy
  # https://dev.twitter.com/docs/api/1.1/post/lists/subscribers/destroy

  # POST lists/members/create_all
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/create_all

  # GET lists/members/show
  # https://dev.twitter.com/docs/api/1.1/get/lists/members/show

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members(slug: "twitter-engineering", owner_screen_name: "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/members
  """
  @spec list_members(Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate list_members(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members("twitter-engineering", "twitter")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/members
  """
  @spec list_members(String.t, String.t) :: [ExTwitter.Model.User.t]
  defdelegate list_members(list, owner), to: ExTwitter.API.Lists

  @doc """
  GET lists/members

  ## Examples

      ExTwitter.list_members("twitter-engineering", "twitter", count: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/lists/members
  """
  @spec list_members(String.t, String.t, Keyword.t) :: [ExTwitter.Model.User.t]
  defdelegate list_members(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/members/create
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/create

  # POST lists/destroy
  # https://dev.twitter.com/docs/api/1.1/post/lists/destroy

  # POST lists/update
  # https://dev.twitter.com/docs/api/1.1/post/lists/update

  # POST lists/create
  # https://dev.twitter.com/docs/api/1.1/post/lists/create

  # GET lists/show
  # https://dev.twitter.com/docs/api/1.1/get/lists/show

  # GET lists/subscriptions
  # https://dev.twitter.com/docs/api/1.1/get/lists/subscriptions

  # POST lists/members/destroy_all
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy_all

  # GET lists/ownerships
  # https://dev.twitter.com/docs/api/1.1/get/lists/ownerships

  # -------------- Saved Searches -------------

  # -------------- Places & Geo -------------

  # GET geo/id/:place_id
  # https://dev.twitter.com/docs/api/1.1/get/geo/id/%3Aplace_id

  @doc """
  GET geo/reverse_geocode

  ## Examples

      ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/geo/reverse_geocode
  """
  @spec reverse_geocode(float, float) :: [ExTwitter.Model.Place.t]
  defdelegate reverse_geocode(lat, long), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/reverse_geocode

  ## Examples

      ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116, max_results: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/geo/reverse_geocode
  """
  @spec reverse_geocode(float, float, Keyword.t) :: [ExTwitter.Model.Place.t]
  defdelegate reverse_geocode(lat, long, options), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/search

  ## Examples

      ExTwitter.geo_search("new york")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/geo/search
  """
  @spec geo_search(String.t) :: [ExTwitter.Model.Place.t]
  defdelegate geo_search(query), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/search

  ## Examples

      ExTwitter.geo_search("new york", max_results: 1)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/geo/search
  """
  @spec geo_search(String.t, Keyword.t) :: [ExTwitter.Model.Place.t]
  defdelegate geo_search(query, options), to: ExTwitter.API.PlacesAndGeo

  # GET geo/similar_places
  # https://dev.twitter.com/docs/api/1.1/get/geo/similar_places

  # POST geo/place
  # https://dev.twitter.com/docs/api/1.1/post/geo/place

  # -------------- Trends -------------

  @doc """
  GET trends/place

  ## Examples

      ExTwitter.trends(1)

  ## Reference
  https://dev.twitter.com/rest/reference/get/trends/place
  """
  @spec trends(Integer | String.t) :: [ExTwitter.Model.Trend.t]
  defdelegate trends(id), to: ExTwitter.API.Trends

  @doc """
  GET trends/place

  ## Examples

      ExTwitter.trends(1, exclude: true)

  ## Reference
  https://dev.twitter.com/rest/reference/get/trends/place
  """
  @spec trends(Integer | String.t, Keyword.t) :: [ExTwitter.Model.Trend.t]
  defdelegate trends(id, options), to: ExTwitter.API.Trends

  # GET trends/available
  # https://dev.twitter.com/docs/api/1.1/get/trends/available

  # GET trends/closest
  # https://dev.twitter.com/docs/api/1.1/get/trends/closest

  # -------------- Spam Reporting -------------

  # -------------- OAuth -------------

  # -------------- Help -------------

  # GET help/configuration
  # https://dev.twitter.com/docs/api/1.1/get/help/configuration

  # GET help/languages
  # https://dev.twitter.com/docs/api/1.1/get/help/languages

  # GET help/privacy
  # https://dev.twitter.com/docs/api/1.1/get/help/privacy

  # GET help/tos
  # https://dev.twitter.com/docs/api/1.1/get/help/tos

  @doc """
  GET application/rate_limit_status

  ## Examples

      status = ExTwitter.rate_limit_status
      limit = status["resources"]["statuses"]["/statuses/home_timeline"]["remaining"]

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/application/rate_limit_status
  """
  @spec rate_limit_status :: Map
  defdelegate rate_limit_status, to: ExTwitter.API.Help

  @doc """
  GET application/rate_limit_status

  ## Examples

      ExTwitter.rate_limit_status(resources: "statuses")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/application/rate_limit_status
  """
  @spec rate_limit_status(Keyword.t) :: Map
  defdelegate rate_limit_status(options), to: ExTwitter.API.Help

  # -------------- Tweets -------------

  @doc """
  GET statuses/lookup

  ## Examples

      ExTwitter.lookup_status("504692034473435136,502883389347622912")

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/lookup
  """
  @spec lookup_status(String.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate lookup_status(id), to: ExTwitter.API.Tweets

  @doc """
  GET statuses/lookup

  ## Examples

      ExTwitter.lookup_status("504692034473435136,502883389347622912", trim_user: true)

  ## Reference
  https://dev.twitter.com/docs/api/1.1/get/statuses/lookup
  """
  @spec lookup_status(String.t, Keyword.t) :: [ExTwitter.Model.Tweet.t]
  defdelegate lookup_status(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST oauth/request_token

  ## Examples

      ExTwitter.request_token("http://myapp.com/twitter-callback")

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/request_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @spec request_token(String.t) :: [ExTwitter.Model.RequestToken.t]
  defdelegate request_token(redirect_url), to: ExTwitter.API.Auth

  @doc """
  POST oauth/request_token

  ## Examples

      ExTwitter.request_token

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/request_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @spec request_token :: [ExTwitter.Model.RequestToken.t]
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
  @spec authorize_url(String.t, Map.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate authorize_url(oauth_token, options), to: ExTwitter.API.Auth

  @doc """
  GET oauth/authorize

  ## Examples

      token = ExTwitter.request_token
      ExTwitter.authorize_url(token.oauth_token)

  Returns the URL you should redirect the user to for 3-legged authorization
  """
  @spec authorize_url(String.t) :: {:ok, String.t} | {:error, String.t}
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
  @spec authenticate_url(String.t Map.t) :: {:ok, String.t} | {:error, String.t}
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
  @spec authenticate_url(String.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate authenticate_url(oauth_token), to: ExTwitter.API.Auth

  @doc """
  POST oauth/access_token

  ## Examples

      ExTwitter.access_token("OAUTH_VERIFIER", "ACCESS_TOKEN", "ACCESS_TOKEN_SECRET")

  ## Reference
  https://dev.twitter.com/oauth/reference/post/oauth/access_token
  https://dev.twitter.com/web/sign-in/implementing
  """
  @spec access_token(String.t, String.t) :: {:ok, String.t} | {:error, String.t}
  defdelegate access_token(verifier, request_token), to: ExTwitter.API.Auth
end
