defmodule ExTwitter do
  @moduledoc """
  Provides user interface for the Twitter API.
  """

  use Application

  def start(_type, _args) do
    ExTwitter.Supervisor.start_link
  end

  # -------------- ExTwitter Settings -------------

  @doc """
  Provides OAuth configuration setting for accessing twitter server.
  """
  defdelegate configure(oauth), to: ExTwitter.Config, as: :set
  defdelegate configure(scope, oauth), to: ExTwitter.Config, as: :set

  @doc """
  Provides general twitter server access interface, which returns json.
  ex. ExTwitter.request(:get, "1.1/search/tweets.json", [q: "elixir", count: 1])
  """
  defdelegate request(method, path),         to: ExTwitter.API.Base
  defdelegate request(method, path, params), to: ExTwitter.API.Base

  # -------------- Timelines -------------

  @doc """
  GET statuses/mentions_timeline
  https://dev.twitter.com/docs/api/1.1/get/statuses/mentions_timeline
  """
  defdelegate mentions_timeline,          to: ExTwitter.API.Timelines
  defdelegate mentions_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/user_timeline
  https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
  """
  defdelegate user_timeline,          to: ExTwitter.API.Timelines
  defdelegate user_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/home_timeline
  https://dev.twitter.com/docs/api/1.1/get/statuses/home_timeline
  """
  defdelegate home_timeline,          to: ExTwitter.API.Timelines
  defdelegate home_timeline(options), to: ExTwitter.API.Timelines

  @doc """
  GET statuses/retweets_of_me
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets_of_me
  """
  defdelegate retweets_of_me,          to: ExTwitter.API.Timelines
  defdelegate retweets_of_me(options), to: ExTwitter.API.Timelines

  # -------------- Tweets -------------

  @doc """
  GET statuses/retweets/:id
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweets/%3Aid
  """
  defdelegate retweets(id),          to: ExTwitter.API.Tweets
  defdelegate retweets(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/show/:id
  https://dev.twitter.com/docs/api/1.1/get/statuses/show/%3Aid
  """
  defdelegate show(id),          to: ExTwitter.API.Tweets
  defdelegate show(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/destroy/:id
  https://dev.twitter.com/docs/api/1.1/post/statuses/destroy/%3Aid
  """
  defdelegate destroy_status(id),          to: ExTwitter.API.Tweets
  defdelegate destroy_status(id, options), to: ExTwitter.API.Tweets

  @doc """
  POST statuses/update
  https://dev.twitter.com/docs/api/1.1/post/statuses/update
  """
  defdelegate update(status),          to: ExTwitter.API.Tweets
  defdelegate update(status, options), to: ExTwitter.API.Tweets

  # POST statuses/retweet/:id
  # https://dev.twitter.com/docs/api/1.1/post/statuses/retweet/%3Aid

  # POST statuses/update_with_media
  # https://dev.twitter.com/docs/api/1.1/post/statuses/update_with_media

  # GET statuses/oembed
  # https://dev.twitter.com/docs/api/1.1/get/statuses/oembed

  @doc """
  GET statuses/retweeters/ids
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
  """
  defdelegate retweeter_ids(id),          to: ExTwitter.API.Tweets
  defdelegate retweeter_ids(id, options), to: ExTwitter.API.Tweets

  # -------------- Search -------------

  @doc """
  GET search/tweets
  https://dev.twitter.com/docs/api/1.1/get/search/tweets
  """
  defdelegate search(query),          to: ExTwitter.API.Search
  defdelegate search(query, options), to: ExTwitter.API.Search

  # -------------- Streaming -------------

  @doc """
  GET statuses/sample
  https://dev.twitter.com/docs/api/1.1/get/statuses/sample
  """
  defdelegate stream_sample,          to: ExTwitter.API.Streaming
  defdelegate stream_sample(options), to: ExTwitter.API.Streaming

  @doc """
  POST statuses/filter
  https://dev.twitter.com/docs/api/1.1/post/statuses/filter
  """
  defdelegate stream_filter(options),          to: ExTwitter.API.Streaming
  defdelegate stream_filter(options, timeout), to: ExTwitter.API.Streaming

  @doc """
  An interface to control the stream which keeps running infinitely.
  This method is for handling elixir's stream, and it doesn't
  involve twitter API call.

  `pid` is the process id where stream is processed.
  """
  defdelegate stream_control(pid, :stop),          to: ExTwitter.API.Streaming
  defdelegate stream_control(pid, :stop, options), to: ExTwitter.API.Streaming

  # --------------  Direct Messages -------------

  # -------------- Friends & Followers -------------

  # GET friendships/no_retweets/ids
  # https://dev.twitter.com/docs/api/1.1/get/friendships/no_retweets/ids

  # GET friends/ids
  # https://dev.twitter.com/docs/api/1.1/get/friends/ids

  # GET followers/ids
  # https://dev.twitter.com/docs/api/1.1/get/followers/ids

  # GET friendships/incoming
  # https://dev.twitter.com/docs/api/1.1/get/friendships/incoming

  # GET friendships/outgoing
  # https://dev.twitter.com/docs/api/1.1/get/friendships/outgoing

  # POST friendships/create
  # https://dev.twitter.com/docs/api/1.1/post/friendships/create

  # POST friendships/destroy
  # https://dev.twitter.com/docs/api/1.1/post/friendships/destroy

  # POST friendships/update
  # https://dev.twitter.com/docs/api/1.1/post/friendships/update

  # GET friendships/show
  # https://dev.twitter.com/docs/api/1.1/get/friendships/show

  @doc """
  GET followers/list
  https://dev.twitter.com/docs/api/1.1/get/followers/list
  """
  defdelegate followers(options) when is_list(options), to: ExTwitter.API.FriendsAndFollowers
  defdelegate followers(screen_name),                   to: ExTwitter.API.FriendsAndFollowers
  defdelegate followers(screen_name, options),          to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list
  https://dev.twitter.com/docs/api/1.1/get/friends/list
  """
  defdelegate friends(options) when is_list(options),   to: ExTwitter.API.FriendsAndFollowers
  defdelegate friends(screen_name),                     to: ExTwitter.API.FriendsAndFollowers
  defdelegate friends(screen_name, options),            to: ExTwitter.API.FriendsAndFollowers

  # GET friendships/lookup
  # https://dev.twitter.com/docs/api/1.1/get/friendships/lookup

  # -------------- Users -------------

  # GET account/settings
  # https://dev.twitter.com/docs/api/1.1/get/account/settings

  # GET account/verify_credentials
  # https://dev.twitter.com/docs/api/1.1/get/account/verify_credentials

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

  # GET users/lookup
  # https://dev.twitter.com/docs/api/1.1/get/users/lookup
  defdelegate user_lookup(options) when is_list(options), to: ExTwitter.API.Users
  defdelegate user_lookup(screen_name),                   to: ExTwitter.API.Users
  defdelegate user_lookup(screen_name, options),          to: ExTwitter.API.Users

  @doc """
  GET users/show
  https://dev.twitter.com/docs/api/1.1/get/users/show
  """
  defdelegate user(user_id, screen_name),          to: ExTwitter.API.Users
  defdelegate user(user_id, screen_name, options), to: ExTwitter.API.Users

  @doc """
  GET users/search
  https://dev.twitter.com/docs/api/1.1/get/users/search
  """
  defdelegate user_search(query),          to: ExTwitter.API.Users
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
  https://dev.twitter.com/docs/api/1.1/get/favorites/list
  """
  defdelegate favorites,          to: ExTwitter.API.Favorites
  defdelegate favorites(options), to: ExTwitter.API.Favorites

  # POST favorites/destroy
  # https://dev.twitter.com/docs/api/1.1/post/favorites/destroy

  # POST favorites/create
  # https://dev.twitter.com/docs/api/1.1/post/favorites/create

  # -------------- Lists -------------

  @doc """
  GET lists/list
  https://dev.twitter.com/docs/api/1.1/get/lists/list
  """
  defdelegate lists(screen_name),          to: ExTwitter.API.Lists
  defdelegate lists(screen_name, options), to: ExTwitter.API.Lists

  @doc """
  GET lists/statuses
  https://dev.twitter.com/docs/api/1.1/get/lists/statuses
  """
  defdelegate list_timeline(options),              to: ExTwitter.API.Lists
  defdelegate list_timeline(list, owner),          to: ExTwitter.API.Lists
  defdelegate list_timeline(list, owner, options), to: ExTwitter.API.Lists

  # POST lists/members/destroy
  # https://dev.twitter.com/docs/api/1.1/post/lists/members/destroy

  @doc """
  GET lists/memberships
  https://dev.twitter.com/docs/api/1.1/get/lists/memberships
  """
  defdelegate list_memberships,          to: ExTwitter.API.Lists
  defdelegate list_memberships(options), to: ExTwitter.API.Lists

  @doc """
  GET lists/subscribers
  https://dev.twitter.com/docs/api/1.1/get/lists/subscribers
  """
  defdelegate list_subscribers(options),              to: ExTwitter.API.Lists
  defdelegate list_subscribers(list, owner),          to: ExTwitter.API.Lists
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

  # GET lists/members
  # https://dev.twitter.com/docs/api/1.1/get/lists/members
  defdelegate list_members(options),              to: ExTwitter.API.Lists
  defdelegate list_members(list, owner),          to: ExTwitter.API.Lists
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
  https://dev.twitter.com/docs/api/1.1/get/geo/reverse_geocode
  """
  defdelegate reverse_geocode(lat, long),          to: ExTwitter.API.PlacesAndGeo
  defdelegate reverse_geocode(lat, long, options), to: ExTwitter.API.PlacesAndGeo

  @doc """
  GET geo/search
  https://dev.twitter.com/docs/api/1.1/get/geo/search
  """
  defdelegate geo_search(query),          to: ExTwitter.API.PlacesAndGeo
  defdelegate geo_search(query, options), to: ExTwitter.API.PlacesAndGeo

  # GET geo/similar_places
  # https://dev.twitter.com/docs/api/1.1/get/geo/similar_places

  # POST geo/place
  # https://dev.twitter.com/docs/api/1.1/post/geo/place

  # -------------- Trends -------------

  @doc """
  GET trends/place
  https://api.twitter.com/1.1/trends/place.json
  """
  defdelegate trends(id),          to: ExTwitter.API.Trends
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
  https://dev.twitter.com/docs/api/1.1/get/application/rate_limit_status
  """
  defdelegate rate_limit_status,          to: ExTwitter.API.Help
  defdelegate rate_limit_status(options), to: ExTwitter.API.Help

  # -------------- Tweets -------------

  @doc """
  GET statuses/lookup
  https://dev.twitter.com/docs/api/1.1/get/statuses/lookup
  """
  defdelegate lookup_status(id),          to: ExTwitter.API.Tweets
  defdelegate lookup_status(id, options), to: ExTwitter.API.Tweets

end
