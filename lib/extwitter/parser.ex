defmodule ExTwitter.Parser do
  @moduledoc """
  Provides parser logics for API results.
  """

  @doc """
  Parse tweet record from the API response json.
  """
  def parse_tweet(tuples) do
    tweet = tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.Tweet.new
    user  = parse_user(tweet.user)
    tweet.update(user: user)
  end

  @doc """
  Parse user record from the API response json.
  """
  def parse_user(tuples) do
    tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.User.new
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_trend(tuples) do
    trend = tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.Trend.new
    trend.update(query: trend.query |> URI.decode)
  end

  @doc """
  Parse list record from the API response json.
  """
  def parse_list(tuples) do
    list = tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.List.new
    user = parse_user(list.user)
    list.update(user: user)
  end

  @doc """
  Parse trend record from the API response json.
  """
  def parse_ids(tuples) do
    tuple = tuples |> ExTwitter.JSON.parse
    tuple["ids"]
  end

  @doc """
  Parse place record from the API response json.
  """
  def parse_place(tuples) do
    place = tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.Place.new

    geo = parse_geo(place.bounding_box)
    con = Enum.map(place.contained_within, &parse_contained_within/1)

    place.update(bounding_box: geo, contained_within: con)
  end

  defp parse_contained_within(tuples) do
    tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.Place.new
  end

  @doc """
  Parse geo record from the API response json.
  """
  def parse_geo(tuples) do
    case tuples do
      nil    -> nil
      tuples -> tuples |> ExTwitter.JSON.parse
                       |> ExTwitter.Model.Geo.new
    end
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_char_list(k), to_char_list(v)} end)
  end
end