defmodule ExTwitter.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTwitter.API.Base

  def request_token(redirect_url \\ nil) do
    oauth = ExTwitter.Config.get_tuples |> verify_params
    params = if redirect_url, do: [{"oauth_callback", redirect_url}], else: []
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    {:ok, {{_, 200, _}, _headers, body}} =
      ExTwitter.OAuth.request(:post, request_url("oauth/request_token"), params, consumer, [], [])

    Elixir.URI.decode_query(to_string body)
    |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
    |> Enum.into(%{})
    |> ExTwitter.Parser.parse_request_token
  end

  def authorize_url(oauth_token, options \\ %{}) do
    args = Map.merge(%{oauth_token: oauth_token}, options)

    {:ok, request_url("oauth/authorize?" <> Elixir.URI.encode_query(args)) |> to_string}
  end

  def authenticate_url(oauth_token, options \\ %{}) do
    args = Map.merge(%{oauth_token: oauth_token}, options)

    {:ok, request_url("oauth/authenticate?" <> Elixir.URI.encode_query(args)) |> to_string}
  end

  def access_token(verifier, request_token) do
    oauth = ExTwitter.Config.get_tuples |> verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    case ExTwitter.OAuth.request(:post, request_url("oauth/access_token"),
                                 [oauth_verifier: verifier],
                                 consumer, request_token, nil) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        access_token = Elixir.URI.decode_query(to_string body)
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})
        |> ExTwitter.Parser.parse_access_token
        {:ok, access_token}
      {:ok, {{_, code, _}, _, _}} ->
        {:error, code}
    end
  end
end
