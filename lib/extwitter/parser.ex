defmodule ExTwitter.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """
  alias ExTwitter.Model

  @doc """
  Parse tweet record from the API response json.
  """
  @spec parse_tweet(map | nil) :: Model.Tweet.t() | nil
  def parse_tweet(nil), do: nil

  def parse_tweet(object) do
    tweet            = struct(Model.Tweet, object)
    user             = parse_user(tweet.user)
    coordinates      = parse_coordinates(tweet.coordinates)
    place            = parse_place(tweet.place)
    entities         = parse_entities(tweet.entities)
    ex_entities      = parse_extended_entities(tweet.extended_entities)
    rules            = parse_rules(tweet.matching_rules)
    quoted_status    = parse_tweet(tweet.quoted_status)
    retweeted_status = parse_tweet(tweet.retweeted_status)
    %{
      tweet | user: user, coordinates: coordinates, place: place,
      entities: entities, extended_entities: ex_entities,
      matching_rules: rules, quoted_status: quoted_status,
      retweeted_status: retweeted_status, raw_data: object
    }
  end

  @doc """
  Parse direct message record from the API response json.
  """
  def parse_direct_message(object) do
    direct_message = struct(Model.DirectMessage, object)
    recipient      = parse_user(direct_message.recipient)
    sender         = parse_user(direct_message.sender)
    %{direct_message | recipient: recipient, sender: sender}
  end

  @spec parse_upload(map) :: Model.Upload.t()
  def parse_upload(object) do
    Model.Upload |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse user record from the API response json.
  """
  @spec parse_user(map) :: Model.User.t()
  def parse_user(object) do
    user = struct(Model.User, object)
    derived = if user.derived, do: parse_profile_geo(user.derived.locations), else: nil
    %{user | derived: derived, raw_data: object}
  end

  @doc """
  Parse profile geo record from the API response json.
  """
  @spec parse_profile_geo(map | [map] | nil) :: Model.ProfileGeo.t() | [Model.ProfileGeo.t()] | nil
  def parse_profile_geo(nil), do: nil

  def parse_profile_geo(objects) when is_list(objects) do
    Enum.map(objects, &parse_profile_geo/1)
  end

  def parse_profile_geo(object) do
    profile_geo = struct(Model.ProfileGeo, object)
      geo = parse_geo(profile_geo.geo)
      %{profile_geo | geo: geo, raw_data: object}
  end

  @doc """
  Parse trend record from the API response json.
  """
  @spec parse_trend(map) :: Model.Trend.t()
  def parse_trend(object) do
    trend = struct(Model.Trend, object)
    %{trend | query: (trend.query |> URI.decode), raw_data: object}
  end

  @doc """
  Parse list record from the API response json.
  """
  @spec parse_list(map) :: Model.List.t()
  def parse_list(object) do
    list = struct(Model.List, object)
    user = parse_user(list.user)
    %{list | user: user, raw_data: object}
  end

  @doc """
  Parse place record from the API response json.
  """
  @spec parse_place(map | nil) :: Model.Place.t() | nil
  def parse_place(nil), do: nil

  def parse_place(object) do
    place = struct(Model.Place, object)

    bounding_box = parse_bounding_box(place.bounding_box)
    con = Enum.map((place.contained_within || []), &parse_place/1)

    %{place | bounding_box: bounding_box, contained_within: con, raw_data: object}
  end

  @doc """
  Parse bounding box record from the API response json.
  """
  @spec parse_bounding_box(map | nil) :: Model.BoundingBox.t() | nil
  def parse_bounding_box(nil), do: nil
  def parse_bounding_box(object) do
    Model.BoundingBox |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse coordinates record from the API response json.
  """
  @spec parse_coordinates(map | nil) :: Model.Coordinates.t() | nil
  def parse_coordinates(nil), do: nil

  def parse_coordinates(object) do
    Model.Coordinates |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse geo record from the API response json.
  """
  @spec parse_geo(map | nil) :: Model.Geo.t() | nil
  def parse_geo(nil), do: nil

  def parse_geo(object) do
    Model.Geo |> struct(object) |> Map.put(:raw_data, object)
  end

  @spec parse_rules(map | [map] | nil) :: Model.Role.t() | [Model.Role.t()]
  def parse_rules(nil), do: []

  def parse_rules(objects) when is_list(objects) do
    Enum.map(objects, &parse_rules/1)
  end

  def parse_rules(object) do
    Model.Rule |> struct(object) |> Map.put(:raw_data, object)
  end

  @spec parse_entities(map) :: Model.Entities.t()
  def parse_entities(object) do
    %Model.Entities{
      hashtags: parse_hashtags(object[:hashtags]),
      media: parse_media(object[:media]),
      symbols: parse_symbols(object[:symbols]),
      urls: parse_urls(object[:urls]),
      user_mentions: parse_user_mentions(object[:user_mentions]),
      polls: parse_polls(object[:polls]),
      raw_data: object
    }
  end

  @spec parse_extended_entities(map | nil) :: Model.ExtendedEntities.t() | nil
  def parse_extended_entities(nil), do: nil

  def parse_extended_entities(object) do
    %Model.ExtendedEntities{
      hashtags: parse_hashtags(object[:hashtags]),
      media: parse_media(object[:media]),
      symbols: parse_symbols(object[:symbols]),
      urls: parse_urls(object[:urls]),
      user_mentions: parse_user_mentions(object[:user_mentions]),
      polls: parse_polls(object[:polls]),
      raw_data: object
    }
  end

  @doc """
  Parse hashtags record from the API response json.
  """
  @spec parse_hashtags(map | [map] | nil) :: Model.Hashtag.t() | [Model.Hashtag.t()]
  def parse_hashtags(nil), do: []

  def parse_hashtags(objects) when is_list(objects) do
    Enum.map(objects, &parse_hashtags/1)
  end

  def parse_hashtags(object) do
    Model.Hashtag |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse media record from the API response json.
  """
  @spec parse_media(map | [map] | nil) :: Model.Media.t() | [Model.Media.t()]
  def parse_media(nil), do: []

  def parse_media(objects) when is_list(objects) do
    Enum.map(objects, &parse_media/1)
  end

  def parse_media(object) do
    media = struct(Model.Media, object)
    sizes = media.sizes |> Stream.map(fn {key, val} -> {key, parse_size(val)} end)
                        |> Enum.into(%{})
    %{media | sizes: sizes, raw_data: object}
  end

  @doc """
  Parse size record from the API response json.
  """
  @spec parse_size(map) :: Model.Size.t()
  def parse_size(object) do
    Model.Size |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse symbols record from the API response json.
  """
  @spec parse_symbols(map | [map] | nil) :: Model.Symbol.t() | [Model.Symbol.t()]
  def parse_symbols(nil), do: []

  def parse_symbols(objects) when is_list(objects) do
    Enum.map(objects, &parse_symbols/1)
  end

  def parse_symbols(object) do
    Model.Symbol |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse urls record from the API response json.
  """
  @spec parse_urls(map | [map] | nil) :: Model.URL.t() | [Model.URL.t()]
  def parse_urls(nil), do: []

  def parse_urls(objects) when is_list(objects) do
    Enum.map(objects, &parse_urls/1)
  end

  def parse_urls(object) do
    Model.URL |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse user mentions record from the API response json.
  """
  @spec parse_user_mentions(map | [map] | nil) :: Model.UserMention.t() | [Model.UserMention.t()]
  def parse_user_mentions(nil), do: []

  def parse_user_mentions(objects) when is_list(objects) do
    Enum.map(objects, &parse_user_mentions/1)
  end

  def parse_user_mentions(object) do
    Model.UserMention |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse polls record from the API response json.
  """
  @spec parse_polls(map | [map] | nil) :: Model.Poll.t() | [Model.Poll.t()]
  def parse_polls(nil), do: []

  def parse_polls(objects) when is_list(objects) do
    Enum.map(objects, &parse_polls/1)
  end

  def parse_polls(object) do
    Model.Poll |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse trend record from the API response json.
  """
  @spec parse_ids(map) :: [pos_integer]
  def parse_ids(object) do
    Enum.find(object, fn({key, _value}) -> key == :ids end) |> elem(1)
  end

  @doc """
  Parse cursored ids.
  """
  @spec parse_ids_with_cursor(map) :: Model.Cursor.t()
  def parse_ids_with_cursor(object) do
    ids = object |> ExTwitter.JSON.get(:ids)
    cursor = struct(Model.Cursor, object)
    %{cursor | items: ids, raw_data: object}
  end

  @doc """
  Parse cursored users.
  """
  @spec parse_users_with_cursor(map) :: Model.Cursor.t()
  def parse_users_with_cursor(object) do
    users = object |> ExTwitter.JSON.get(:users)
                   |> Enum.map(&ExTwitter.Parser.parse_user/1)
    cursor = struct(Model.Cursor, object)
    %{cursor | items: users, raw_data: object}
  end

  @doc """
  Parse request parameters for the API.
  """
  @spec parse_request_params(keyword) :: [{String.t(), String.t()}]
  def parse_request_params(options) do
    Enum.map(options, &stringify_params/1)
  end

  @doc """
  Parse batch user/lookup request parameters for the API.
  """
  @spec parse_batch_user_lookup_params(keyword) :: [{String.t(), String.t()}]
  def parse_batch_user_lookup_params(options) do
    Enum.map(options, &stringify_params/1)
  end

  @doc """
  Parse request_token response
  """
  @spec parse_request_token(map) :: Model.RequestToken.t()
  def parse_request_token(object) do
    Model.RequestToken |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse access_token response
  """
  @spec parse_access_token(map) :: Model.AccessToken.t()
  def parse_access_token(object) do
    Model.AccessToken |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse user profile banner from the API response json.
  """
  @spec parse_profile_banner(map) :: Model.ProfileBanner.t()
  def parse_profile_banner(object) do
    Model.ProfileBanner |> struct(object) |> Map.put(:raw_data, object)
  end

  @doc """
  Parse follower relationship from the API response json.
  """
  @spec parse_relationships(map) :: [Model.Relationship.t()]
  def parse_relationships(object) do
    Enum.map(object, fn relation ->
      Model.Relationship |> struct(relation) |> Map.put(:raw_data, relation)
    end)
  end

  @spec stringify_params({any, [any] | any}) :: {String.t(), String.t()}
  defp stringify_params({key, values}) when is_list(values) do
    {to_string(key), Enum.join(values, ",")}
  end

  defp stringify_params({key, value}) do
    {to_string(key), to_string(value)}
  end
end
