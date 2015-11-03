defmodule ExTwitter.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """

  @doc """
  Parse tweet record from the API response json.
  """
  def parse_tweet(object) do
    tweet = struct(ExTwitter.Model.Tweet, object)
    user  = parse_user(tweet.user)
    %{tweet | user: user}
  end

  @doc """
  Parse direct message record from the API response
  """
  def parse_direct_message(object) do
    direct_message = struct(ExTwitter.Model.DirectMessage, object)
    recipient      = parse_user(direct_message.recipient)
    sender         = parse_user(direct_message.sender)
    %{direct_message | recipient: recipient, sender: sender}
  end

  def parse_upload(object) do
    struct(ExTwitter.Model.Upload, object)
  end


  @doc """
  Parse user record from the API response json.
  """
  def parse_user(object) do
    struct(ExTwitter.Model.User, object)
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_trend(object) do
    trend = struct(ExTwitter.Model.Trend, object)
    %{trend | query: (trend.query |> URI.decode)}
  end

  @doc """
  Parse list record from the API response json.
  """
  def parse_list(object) do
    list = struct(ExTwitter.Model.List, object)
    user = parse_user(list.user)
    %{list | user: user}
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_ids(object) do
    Enum.find(object, fn({key, _value}) -> key == :ids end) |> elem(1)
  end

  @doc """
  Parse cursored ids.
  """
  def parse_ids_with_cursor(object) do
    ids = object |> ExTwitter.JSON.get(:ids)
    cursor = struct(ExTwitter.Model.Cursor, object)
    %{cursor | items: ids}
  end

  @doc """
  Parse cursored users.
  """
  def parse_users_with_cursor(object) do
    users = object |> ExTwitter.JSON.get(:users)
                   |> Enum.map(&ExTwitter.Parser.parse_user/1)
    cursor = struct(ExTwitter.Model.Cursor, object)
    %{cursor | items: users}
  end

  @doc """
  Parse place record from the API response json.
  """
  def parse_place(object) do
    place = struct(ExTwitter.Model.Place, object)

    geo = parse_geo(place.bounding_box)
    con = Enum.map(place.contained_within, &parse_contained_within/1)

    %{place | bounding_box: geo, contained_within: con}
  end

  defp parse_contained_within(object) do
    struct(ExTwitter.Model.Place, object)
  end

  @doc """
  Parse geo record from the API response json.
  """
  def parse_geo(object) do
    case object do
      nil    -> nil
      object -> struct(ExTwitter.Model.Geo, object)
    end
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_string(k), to_string(v)} end)
  end

  @doc """
  Parse request_token response
  """
  def parse_request_token(object) do
    struct(ExTwitter.Model.RequestToken, object)
  end

  @doc """
  Parse access_token response
  """
  def parse_access_token(object) do
    struct(ExTwitter.Model.AccessToken, object)
  end
end
