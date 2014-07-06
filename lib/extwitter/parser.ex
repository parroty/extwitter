defmodule ExTwitter.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """

  @doc """
  Parse tweet record from the API response json.
  """
  def parse_tweet(tuples) do
    tweet = tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.Tweet{})
    user  = parse_user(tweet.user)
    %{tweet | user: user}
  end

  @doc """
  Parse user record from the API response json.
  """
  def parse_user(tuples) do
    tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.User{})
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_trend(tuples) do
    trend = tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.Trend{})
    %{trend | query: (trend.query |> URI.decode)}
  end

  @doc """
  Parse list record from the API response json.
  """
  def parse_list(tuples) do
    list = tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.List{})
    user = parse_user(list.user)
    %{list | user: user}
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_ids(tuples) do
    tuple = tuples |> ExTwitter.JSON.parse
    Enum.find(tuple, fn({key, _value}) -> key == "ids" end) |> elem(1)
  end

  @doc """
  Parse place record from the API response json.
  """
  def parse_place(tuples) do
    place = tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.Place{})

    geo = parse_geo(place.bounding_box)
    con = Enum.map(place.contained_within, &parse_contained_within/1)

    %{place | bounding_box: geo, contained_within: con}
  end

  defp parse_contained_within(tuples) do
    tuples |> ExTwitter.JSON.parse |> merge_map(%ExTwitter.Model.Place{})
  end

  @doc """
  Parse geo record from the API response json.
  """
  def parse_geo(tuples) do
    case tuples do
      nil    -> nil
      tuples -> tuples |> ExTwitter.JSON.parse
                       |> merge_map(%ExTwitter.Model.Geo{})
    end
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_char_list(k), to_char_list(v)} end)
  end

  defp merge_map(json, struct) do
    keys = Map.keys(struct)
    Enum.reduce(keys, struct, fn(key, acc) ->
      atom_key = Atom.to_string(key)
      if atom_key != "__struct__" and Map.has_key?(json, atom_key) do
        Map.put(acc, key, Map.fetch!(json, atom_key))
      else
        acc
      end
    end)
  end
end