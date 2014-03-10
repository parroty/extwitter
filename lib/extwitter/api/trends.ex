defmodule ExTwitter.API.Trends do
  @moduledoc """
  Provides trends API interfaces.
  """

  import ExTwitter.API.Base

  def trends(id, options \\ []) do
    json = request(:get, "1.1/trends/place.json", [id: id] ++ options |> ExTwitter.Parser.parse_request_params)
    List.first(json) |> ExTwitter.JSON.get("trends") |> Enum.map(&ExTwitter.Parser.parse_trend/1)
  end
end
