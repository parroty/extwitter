defmodule ExTwitter.API.Timelines do
  @moduledoc """
  Provides timeline API interfaces.
  """

  import ExTwitter.API.Base

  def mentions_timeline(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/mentions_timeline.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def user_timeline(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/user_timeline.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def home_timeline(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/home_timeline.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def retweets_of_me(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/retweets_of_me.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

end
