defmodule ExTwitter.OAuth do
  @moduledoc """
  Provide a wrapper for :oauth request methods.
  """

  @doc """
  Send request with get method.
  """
  def request(:get, url, params, consumer, access_token, access_token_secret) do
    :oauth.get(url, params, consumer, access_token, access_token_secret)
  end

  @doc """
  Send request with post method.
  """
  def request(:post, url, params, consumer, access_token, access_token_secret) do
    :oauth.post(url, params, consumer, access_token, access_token_secret)
  end
end
