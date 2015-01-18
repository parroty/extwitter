defmodule ExTwitter.API.FriendsAndFollowers do
  @moduledoc """
  Provides friends and followers API interfaces.
  """

  import ExTwitter.API.Base

  def followers(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/followers/list.json", params)
      |> ExTwitter.Parser.parse_users_with_cursor
  end

  def followers(screen_name, options \\ []) do
    followers([screen_name: screen_name] ++ options)
  end

  def friends(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/friends/list.json", params)
      |> ExTwitter.Parser.parse_users_with_cursor
  end

  def friends(screen_name, options \\ []) do
    friends([screen_name: screen_name] ++ options)
  end

  def follower_ids(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/followers/ids.json", params)
      |> ExTwitter.Parser.parse_ids_with_cursor
  end

  def follower_ids(screen_name, options \\ []) do
    follower_ids([screen_name: screen_name] ++ options)
  end
end
