defmodule ExTwitter.API.Tweets do
  @moduledoc """
  Provides Tweets API interfaces.
  """

  import ExTwitter.API.Base

  def show(id, options \\ []) do
    params = options |> ExTwitter.Parser.parse_request_params
    request(:get, "1.1/statuses/show/#{id}.json", params)
      |> ExTwitter.Parser.parse_tweet
  end

  def update(status, options \\ []) do
    params = [status: status] ++ options |> ExTwitter.Parser.parse_request_params
    request(:post, "1.1/statuses/update.json", params)
      |> ExTwitter.Parser.parse_tweet
  end

  def destroy_status(id, options \\ []) do
    params = options |> ExTwitter.Parser.parse_request_params
    request(:post, "1.1/statuses/destroy/#{id}.json", params)
  end
end
