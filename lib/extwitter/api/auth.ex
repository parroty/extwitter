defmodule ExTwitter.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTwitter.API.Base

  def request_token() do
  	oauth = ExTwitter.Config.get_tuples |> verify_params
  	consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
  	{:ok, {{_, 200, _}, _headers, body}} = ExTwitter.OAuth.request(:post, request_url("oauth/request_token"), [], consumer, [], [])

    Elixir.URI.decode_query(to_string body)
      |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})
      |> ExTwitter.Parser.parse_request_token
  end
end