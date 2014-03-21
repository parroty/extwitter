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
  Parse trend record from the API response json.
  """
  def parse_ids(tuples) do
    dict = tuples |> ExTwitter.JSON.parse |> HashDict.new
    HashDict.get(dict, "ids")
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_char_list(k), to_char_list(v)} end)
  end
end