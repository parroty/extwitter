defmodule ExTwitter.API.Lists do
  @moduledoc """
  Provides lists API interfaces.
  """

  import ExTwitter.API.Base

  def lists(screen_name, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([screen_name: screen_name] ++ options)
    request(:get, "1.1/lists/list.json", params)
      |> Enum.map(&ExTwitter.Parser.parse_list/1)
  end

  def list_timeline(list, owner, options \\ []) do
    list_timeline([slug: list, owner_screen_name: owner] ++ options)
  end

  def list_timeline(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/lists/statuses.json", params)
      |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def list_memberships(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/lists/memberships.json", params)
      |> ExTwitter.JSON.get("lists")
      |> Enum.map(&ExTwitter.Parser.parse_list/1)
  end
end
