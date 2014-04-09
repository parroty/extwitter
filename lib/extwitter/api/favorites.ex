defmodule ExTwitter.API.Favorites do
  @moduledoc """
  Provides favorites API interfaces.
  """

  import ExTwitter.API.Base

  def favorites(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/favorites/list.json", params)
      |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end
end
