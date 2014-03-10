defmodule ExTwitter.API.Trends do
  @moduledoc """
  Provides trends API interfaces.
  """

  import ExTwitter.API.Base

  def trends(id, options \\ []) do
    json = request(:get, "1.1/trends/place.json", [id: id] ++ options |> parse_request_params)
    List.first(json) |> ExTwitter.JSON.get("trends") |> Enum.map(&parse_trend/1)
  end

  defp parse_trend(tuples) do
    trend = tuples |> ExTwitter.JSON.parse |> ExTwitter.Model.Trend.new
    trend.update(query: trend.query |> URI.decode)
  end
end
