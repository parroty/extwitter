defmodule ExTwitter.API.Base do
  @moduledoc """
  Provides basic and common functionalities for Twitter API.
  """

  @doc """
  Send API request to the twitter server.
  """
  def request(method, path, params \\ []) do
    oauth = ExTwitter.Config.get_tuples
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    ExTwitter.OAuth.request(method, request_url(path), params, consumer, oauth[:access_token], oauth[:access_token_secret])
      |> parse_result
  end

  defp request_url(path) do
    "https://api.twitter.com/#{path}" |> to_char_list
  end

  defp parse_result(result) do
    {:ok, {_response, _header, body}} = result
    to_string(body) |> ExTwitter.JSON.decode
  end

  @doc """
  Parse tweet record from the API response json.
  """
  def parse_tweet(tuples) do
    tweet    = tuples         |> ExTwitter.JSON.parse |> ExTwitter.Model.Tweet.new
    user     = tweet.user     |> ExTwitter.JSON.parse |> ExTwitter.Model.User.new
    entities = tweet.entities |> ExTwitter.JSON.parse |> ExTwitter.Model.Entities.new
    tweet.update(user: user, entities: entities)
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_char_list(k), to_char_list(v)} end)
  end
end
