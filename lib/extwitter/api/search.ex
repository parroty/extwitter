defmodule ExTwitter.API.Search do
  @moduledoc """
  Provides search API interfaces.
  """

  import ExTwitter.API.Base

  def search(query, options \\ []) do
    case Keyword.fetch(options, :search_metadata) do
      {:ok, true} -> do_search_with_metadata(query, Keyword.drop(options, [:search_metadata]))
      _ -> do_search(query, options)
    end
  end

  def search_next_page(metadata) do
    if metadata[:next_results] != nil do
      results = String.replace_leading(metadata[:next_results], "?", "")
      params = Map.to_list(URI.decode_query(results))
      json = request(:get, "1.1/search/tweets.json", params)
      statuses = ExTwitter.JSON.get(json, :statuses) |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
      metadata = ExTwitter.JSON.get(json, :search_metadata)
      %{statuses: statuses, metadata: metadata}
    else
      nil
    end
  end

  def do_search_with_metadata(query, options) do
    params = ExTwitter.Parser.parse_request_params([q: query] ++ options)
    json = request(:get, "1.1/search/tweets.json", params)
    statuses = ExTwitter.JSON.get(json, :statuses) |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
    metadata = ExTwitter.JSON.get(json, :search_metadata)
    %{statuses: statuses, metadata: metadata}
  end

  def do_search(query, options) do
    params = ExTwitter.Parser.parse_request_params([q: query] ++ options)
    json = request(:get, "1.1/search/tweets.json", params)
    ExTwitter.JSON.get(json, :statuses) |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end
end
