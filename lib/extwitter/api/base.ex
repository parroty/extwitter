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
    to_string(body) |> JSEX.decode! |> verify_response
  end

  @doc """
  Verify the API request response, and raises error if response includes error response.
  """
  def verify_response([{"errors", details}]), do: raise(ExTwitter.Error, message: inspect details)
  def verify_response(tuples), do: tuples

  @doc """
  Parse tweet record from the API response json.
  """
  def parse_tweet(tuples) do
    tweet    = ExTwitter.Model.Tweet.new(tuples)
    user     = ExTwitter.Model.User.new(tweet.user)
    entities = ExTwitter.Model.Entities.new(tweet.entities)
    tweet.update(user: user, entities: entities)
  end

  @doc """
  Parse request parameters for the API.
  """
  def parse_request_params(options) do
    Enum.map(options, fn({k,v}) -> {to_char_list(k), to_char_list(v)} end)
  end
end
