defmodule ExTwitter.API.FriendsAndFollowers do
  @moduledoc """
  Provides friends and followers API interfaces.
  """

  import ExTwitter.API.Base

  def followers(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    json = request(:get, "1.1/followers/list.json", params)
    json |> ExTwitter.JSON.get("users") |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def followers(screen_name, options \\ []) do
    followers([screen_name: screen_name] ++ options)
  end

  def friends(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    json = request(:get, "1.1/friends/list.json", params)
    json |> ExTwitter.JSON.get("users") |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def friends(screen_name, options \\ []) do
    friends([screen_name: screen_name] ++ options)
  end
end
