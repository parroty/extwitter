defmodule ExTwitter do
  @moduledoc """
  Provides user interface for the Twitter API.
  """

  use Application.Behaviour

  @doc """
  GET statuses/user_timeline
  https://dev.twitter.com/docs/api/1.1/get/statuses/user_timeline
  """
  defdelegate user_timeline,          to: ExTwitter.API.Timelines
  defdelegate user_timeline(options), to: ExTwitter.API.Timelines

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

  @doc """
  GET statuses/retweeters/ids
  https://dev.twitter.com/docs/api/1.1/get/statuses/retweeters/ids
  """
  defdelegate retweeter_ids(id),          to: ExTwitter.API.Tweets
  defdelegate retweeter_ids(id, options), to: ExTwitter.API.Tweets

  @doc """
  GET search/tweets
  https://dev.twitter.com/docs/api/1.1/get/search/tweets
  """
  defdelegate search(query),          to: ExTwitter.API.Search
  defdelegate search(query, options), to: ExTwitter.API.Search

  @doc """
  GET lists/statuses
  https://dev.twitter.com/docs/api/1.1/get/lists/statuses
  """
  defdelegate list_timeline(options),              to: ExTwitter.API.Lists
  defdelegate list_timeline(list, owner),          to: ExTwitter.API.Lists
  defdelegate list_timeline(list, owner, options), to: ExTwitter.API.Lists

  @doc """
  GET trends/place
  https://api.twitter.com/1.1/trends/place.json
  """
  defdelegate trends(id),          to: ExTwitter.API.Trends
  defdelegate trends(id, options), to: ExTwitter.API.Trends

  @doc """
  GET followers/list
  https://api.twitter.com/1.1/followers/list.json
  """
  defdelegate followers(screen_name),          to: ExTwitter.API.FriendsAndFollowers
  defdelegate followers(screen_name, options), to: ExTwitter.API.FriendsAndFollowers

  @doc """
  GET friends/list
  https://api.twitter.com/1.1/friends/list.json
  """
  defdelegate friends(screen_name),          to: ExTwitter.API.FriendsAndFollowers
  defdelegate friends(screen_name, options), to: ExTwitter.API.FriendsAndFollowers


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

  @doc """
  Provides OAuth configuration setting for accessing twitter server.
  """
  defdelegate configure(oauth), to: ExTwitter.Config, as: :set

  def start(_type, _args) do
    ExTwitter.Config.start
    ExTwitter.Supervisor.start_link
  end
end
