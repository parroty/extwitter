defmodule ExTwitter.API.PlacesAndGeo do
  @moduledoc """
  Provides places and geo API interfaces.
  """

  import ExTwitter.API.Base

  def geo_search(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/geo/search.json", params)
    |> ExTwitter.JSON.get(:result)
    |> ExTwitter.JSON.get(:places)
    |> Enum.map(&ExTwitter.Parser.parse_place/1)
  end

  def geo_search(query, options \\ []) do
    geo_search([query: query] ++ options)
  end

  def reverse_geocode(lat, long, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([lat: lat, long: long] ++ options)
    request(:get, "1.1/geo/reverse_geocode.json", params)
    |> ExTwitter.JSON.get(:result)
    |> ExTwitter.JSON.get(:places)
    |> Enum.map(&ExTwitter.Parser.parse_place/1)
  end
end
