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

  def create_favorite(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:post, "1.1/favorites/create.json", params)
    |> ExTwitter.Parser.parse_tweet
  end

  def destroy_favorite(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:post, "1.1/favorites/destroy.json", params)
    |> ExTwitter.Parser.parse_tweet
  end
end
