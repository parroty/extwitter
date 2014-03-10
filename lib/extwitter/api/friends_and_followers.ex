defmodule ExTwitter.API.FriendsAndFollowers do
  @moduledoc """
  Provides friends and followers API interfaces.
  """

  import ExTwitter.API.Base

  def followers(options) when is_list(options) do
    json = request(:get, "1.1/followers/list.json", options |> parse_request_params)
    json |> ExTwitter.JSON.get("users") |> Enum.map(&parse_user/1)
  end

  def followers(screen_name, options \\ []) do
    followers([screen_name: screen_name] ++ options)
  end

  defp parse_user(tuples) do
    tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.User.new
  end
end
