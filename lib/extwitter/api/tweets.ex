defmodule ExTwitter.API.Tweets do
  @moduledoc """
  Provides Tweets API interfaces.
  """

  import ExTwitter.API.Base

  def update(status, options \\ []) do
    request(:post, "1.1/statuses/update.json", [status: status] ++ options |> parse_request_params)
      |> parse_tweet
  end

  def destroy_status(id, options \\ []) do
    request(:post, "1.1/statuses/destroy/#{id}.json", [id: id] ++ options |> parse_request_params)
  end
end
