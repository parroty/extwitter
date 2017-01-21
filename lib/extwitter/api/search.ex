defmodule ExTwitter.API.Search do
  @moduledoc """
  Provides search API interfaces.
  """

  import ExTwitter.API.Base

  def search(query, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([q: query] ++ options)
    case request(:get, "1.1/search/tweets.json", params) do
      {:error, msg} -> {:error, msg}
      json ->
        json
        |> ExTwitter.JSON.get(:statuses)
        |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
    end
  end
end
