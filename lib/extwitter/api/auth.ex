defmodule ExTwitter.API.Auth do
  @moduledoc """
  Provides Authorization and Authentication API interfaces.
  """
  import ExTwitter.API.Base

  def request_token(redirect_url \\ nil) do
    oauth = ExTwitter.Config.get_tuples |> verify_params
    params = if redirect_url, do: [{"oauth_callback", redirect_url}], else: []
    response =
      ExTwitter.OAuth.request(:post, request_url("oauth/request_token"),
        params, oauth[:consumer_key], oauth[:consumer_secret], "", "")

    case response do
      {:ok, {{_, 200, _}, _headers, body}} ->
        token =
          Elixir.URI.decode_query(to_string body)
          |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
          |> Enum.into(%{})
          |> ExTwitter.Parser.parse_request_token
        {:ok, token}
      _ -> {:error, :unknown}
    end
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
    response = ExTwitter.OAuth.request(:post, request_url("oauth/access_token"),
      [{"oauth_verifier", verifier}], oauth[:consumer_key], oauth[:consumer_secret], request_token, nil)
    case response do
      {:ok, {{_, 200, _}, _headers, body}} ->
        access_token = Elixir.URI.decode_query(to_string body)
        |> Enum.map(fn {k,v} -> {String.to_atom(k), v} end)
        |> Enum.into(%{})
        |> ExTwitter.Parser.parse_access_token
        {:ok, access_token}
      _ -> {:error, :unknown}
    end
  end
end

