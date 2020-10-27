defmodule ExTwitter.Behaviour do
  @moduledoc """
  A definition of the intended behavior of the core functions.
  """

  @callback configure(Keyword.t()) :: :ok
  @callback configure(:global | :process, Keyword.t()) :: :ok
  @callback configure() :: Keyword.t() | nil
  @callback request(:get | :post, String.t()) :: map()
  @callback request(:get | :post, String.t(), Keyword.t()) :: map()
  @callback mentions_timeline :: [ExTwitter.Model.Tweet.t()]
  @callback mentions_timeline(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback user_timeline :: [ExTwitter.Model.Tweet.t()]
  @callback user_timeline(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback home_timeline :: [ExTwitter.Model.Tweet.t()]
  @callback home_timeline(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback retweets_of_me :: [ExTwitter.Model.Tweet.t()]
  @callback retweets_of_me(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback retweets(integer() | String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback retweets(integer() | String.t(), Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback show(integer() | String.t()) :: ExTwitter.Model.Tweet.t()
  @callback show(integer() | String.t(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback destroy_status(integer()) :: ExTwitter.Model.Tweet.t()
  @callback destroy_status(integer(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback update(String.t()) :: ExTwitter.Model.Tweet.t()
  @callback update(String.t(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback retweet(integer()) :: ExTwitter.Model.Tweet.t()
  @callback retweet(integer(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback unretweet(integer()) :: ExTwitter.Model.Tweet.t()
  @callback unretweet(integer(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback update_with_media(String.t(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback update_with_media(String.t(), String.t(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback update_with_chunked_media(String.t(), String.t(), String.t()) :: ExTwitter.Model.Tweet.t()
  @callback update_with_chunked_media(String.t(), String.t(), String.t(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback upload_media(String.t(), String.t()) :: integer()
  @callback upload_media(String.t(), String.t(), integer()) :: integer()
  @callback retweeter_ids(integer() | String.t()) :: [integer() | String.t()]
  @callback retweeter_ids(integer() | String.t(), Keyword.t()) :: [integer() | String.t()]
  @callback search(String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback search(String.t(), Keyword.t()) ::
              [ExTwitter.Model.Tweet.t()] | ExTwitter.Model.SearchResponse.t()
  @callback search_next_page(String.t()) :: [map()]
  @callback stream_sample :: Enumerable.t()
  @callback stream_user :: Enumerable.t()
  @callback stream_user(Keyword.t()) :: Enumerable.t()
  @callback stream_user(Keyword.t(), integer()) :: Enumerable.t()
  @callback stream_sample(Keyword.t()) :: Enumerable.t()
  @callback stream_filter(Keyword.t()) :: Enumerable.t()
  @callback stream_filter(Keyword.t(), timeout) :: Enumerable.t()
  @type stream_control_type :: :stop
  @callback stream_control(pid, stream_control_type) :: :ok
  @callback stream_control(pid, stream_control_type, timeout: integer()) :: :ok
  @callback direct_message(integer() | String.t()) :: ExTwitter.Model.DirectMessage.t()
  @callback direct_messages :: [ExTwitter.Model.DirectMessage.t()]
  @callback direct_messages(Keyword.t()) :: [ExTwitter.Model.DirectMessage.t()]
  @callback sent_direct_messages :: [ExTwitter.Model.DirectMessage.t()]
  @callback sent_direct_messages(Keyword.t()) :: [ExTwitter.Model.DirectMessage.t()]
  @callback new_direct_message(String.t() | integer(), String.t()) ::
              ExTwitter.Model.DirectMessage.t()
  @callback destroy_direct_message(integer()) :: ExTwitter.Model.DirectMessage.t()
  @callback destroy_direct_message(integer(), Keyword.t()) :: ExTwitter.Model.DirectMessage.t()
  @callback friend_ids(String.t() | integer() | Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback friend_ids(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback follower_ids(String.t() | integer() | Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback follower_ids(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback follow(String.t() | integer()) :: ExTwitter.Model.User.t()
  @callback follow(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.User.t()
  @callback unfollow(String.t() | integer()) :: ExTwitter.Model.User.t()
  @callback followers(String.t() | integer() | Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback followers(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback friends(String.t() | integer() | Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback friends(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.Cursor.t()
  @callback verify_credentials() :: ExTwitter.Model.User.t()
  @callback verify_credentials(Keyword.t()) :: ExTwitter.Model.User.t()
  @callback block(String.t() | integer()) :: ExTwitter.Model.User.t()
  @callback unblock(String.t() | integer()) :: ExTwitter.Model.User.t()
  @callback user_lookup(String.t() | integer() | Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback user_lookup([String.t() | integer()] | String.t() | integer(), Keyword.t()) :: [
              ExTwitter.Model.User.t()
            ]
  @callback user_profile_banner(String.t() | integer()) :: ExTwitter.Model.ProfileBanner.t()
  @callback user(String.t() | integer()) :: ExTwitter.Model.User.t()
  @callback user(String.t() | integer(), Keyword.t()) :: ExTwitter.Model.User.t()
  @callback user_search(String.t()) :: [ExTwitter.Model.User.t()]
  @callback user_search(String.t(), Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback favorites :: [ExTwitter.Model.Tweet.t()]
  @callback favorites(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback create_favorite(integer(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback destroy_favorite(integer(), Keyword.t()) :: ExTwitter.Model.Tweet.t()
  @callback lists(String.t() | integer()) :: [ExTwitter.Model.List.t()]
  @callback lists(String.t() | integer(), Keyword.t()) :: [ExTwitter.Model.List.t()]
  @callback list_timeline(Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback list_timeline(String.t(), String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback list_timeline(String.t(), String.t(), Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback list_memberships :: [ExTwitter.Model.List.t()]
  @callback list_memberships(Keyword.t()) :: [ExTwitter.Model.List.t()]
  @callback list_subscribers(Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback list_subscribers(String.t(), String.t()) :: [ExTwitter.Model.User.t()]
  @callback list_subscribers(String.t(), String.t(), Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback list_members(Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback list_members(String.t(), String.t()) :: [ExTwitter.Model.User.t()]
  @callback list_members(String.t(), String.t(), Keyword.t()) :: [ExTwitter.Model.User.t()]
  @callback reverse_geocode(float, float) :: [ExTwitter.Model.Place.t()]
  @callback reverse_geocode(float, float, Keyword.t()) :: [ExTwitter.Model.Place.t()]
  @callback geo_search(String.t()) :: [ExTwitter.Model.Place.t()]
  @callback geo_search(String.t(), Keyword.t()) :: [ExTwitter.Model.Place.t()]
  @callback trends(integer() | String.t()) :: [ExTwitter.Model.Trend.t()]
  @callback trends(integer() | String.t(), Keyword.t()) :: [ExTwitter.Model.Trend.t()]
  @callback rate_limit_status() :: map()
  @callback rate_limit_status(Keyword.t()) :: map()
  @callback lookup_status(String.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback lookup_status(String.t(), Keyword.t()) :: [ExTwitter.Model.Tweet.t()]
  @callback request_token(String.t()) :: ExTwitter.Model.RequestToken.t()
  @callback request_token :: ExTwitter.Model.RequestToken.t()
  @callback authorize_url(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback authorize_url(String.t(), map()) :: {:ok, String.t()} | {:error, String.t()}
  @callback authenticate_url(String.t(), map()) :: {:ok, String.t()} | {:error, String.t()}
  @callback authenticate_url(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  @callback access_token(String.t(), String.t()) :: {:ok, ExTwitter.Model.AccessToken.t()} | {:error, String.t()}
end
