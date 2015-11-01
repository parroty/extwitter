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

  def followers(id, options \\ []) do
    followers(get_id_option(id) ++ options)
  end

  def follower_ids(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/followers/ids.json", params)
    |> ExTwitter.Parser.parse_ids_with_cursor
  end

  def follower_ids(id, options \\ []) do
    follower_ids(get_id_option(id) ++ options)
  end

  def follow(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(get_id_option(id) ++ options)
    request(:post, "1.1/friendships/create.json", params)
    |> ExTwitter.Parser.parse_user
  end

  def unfollow(id) do
    params = ExTwitter.Parser.parse_request_params(get_id_option(id))
    request(:post, "1.1/friendships/destroy.json", params)
    |> ExTwitter.Parser.parse_user
  end

  def friends(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/friends/list.json", params)
    |> ExTwitter.Parser.parse_users_with_cursor
  end

  def friends(id, options \\ []) do
    friends(get_id_option(id) ++ options)
  end

  def friend_ids(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/friends/ids.json", params)
    |> ExTwitter.Parser.parse_ids_with_cursor
  end

  def friend_ids(id, options \\ []) do
    friend_ids(get_id_option(id) ++ options)
  end
end
