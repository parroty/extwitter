defmodule ExTwitter.API.Lists do
  @moduledoc """
  Provides lists API interfaces.
  """

  import ExTwitter.API.Base

  def lists(id_or_screen_name, options \\ []) do
    id_option = get_id_option(id_or_screen_name)
    params = ExTwitter.Parser.parse_request_params(id_option ++ options)
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
    |> ExTwitter.JSON.get(:lists)
    |> Enum.map(&ExTwitter.Parser.parse_list/1)
  end

  def list_subscribers(list, owner, options \\ []) do
    list_subscribers([slug: list, owner_screen_name: owner] ++ options)
  end

  def list_subscribers(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/lists/subscribers.json", params)
    |> ExTwitter.JSON.get(:users)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def list_members(list, owner, options \\ []) do
    list_members([slug: list, owner_screen_name: owner] ++ options)
  end

  def list_members(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/lists/members.json", params)
    |> ExTwitter.JSON.get(:users)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def add_list_members(list_id, member_ids) do
    add_list_members([list_id: list_id, user_id: member_ids])
  end

  def add_list_members(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/lists/members/create_all.json", params)
    |> ExTwitter.JSON.get(:users)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def create_list(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/lists/create.json", params)
    |> ExTwitter.Parser.parse_list
  end

  def create_list(list_name, options \\ []) do
    create_list([name: list_name] ++ options)
  end

  def destroy_list(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/lists/destroy.json", params)
    |> ExTwitter.Parser.parse_list
  end

  def destroy_list(list_id, options \\ []) do
    destroy_list([list_id: list_id] ++ options)
  end
end
