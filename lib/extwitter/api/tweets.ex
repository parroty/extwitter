defmodule ExTwitter.API.Tweets do
  @moduledoc """
  Provides Tweets API interfaces.
  """

  import ExTwitter.API.Base

  def retweets(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/retweets/#{id}.json", params)
      |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def show(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/show/#{id}.json", params)
      |> ExTwitter.Parser.parse_tweet
  end

  def update(status, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([status: status] ++ options)
    request(:post, "1.1/statuses/update.json", params)
      |> ExTwitter.Parser.parse_tweet
  end

  def destroy_status(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/statuses/destroy/#{id}.json", params)
  end

  def retweeter_ids(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:get, "1.1/statuses/retweeters/ids.json", params)
      |> ExTwitter.Parser.parse_ids
  end

  def lookup_status(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:get, "1.1/statuses/lookup.json", params)
      |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end
end
