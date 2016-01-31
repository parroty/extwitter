defmodule ExTwitter.OAuth do
  @moduledoc """
  Provide a wrapper for :oauth request methods.
  """

  @doc """
  Send request with get method.
  """
  def request(:get, url, params, consumer, access_token, access_token_secret) do
    if has_funtion(:get, 7) do
      :oauth.get(url, params, consumer, access_token, access_token_secret, [], proxy_option)
    else
      :oauth.get(url, params, consumer, access_token, access_token_secret, [])
    end
  end

  @doc """
  Send request with post method.
  """
  def request(:post, url, params, consumer, access_token, access_token_secret) do
    if has_funtion(:post, 7) do
      :oauth.post(url, params, consumer, access_token, access_token_secret, [], proxy_option)
    else
      :oauth.post(url, params, consumer, access_token, access_token_secret, [])
    end
  end

  @doc """
  Send async request with get method.
  """
  def request_async(:get, url, params, consumer, access_token, access_token_secret) do
    if has_funtion(:get, 7) do
      :oauth.get(url, params, consumer, access_token, access_token_secret, stream_option, proxy_option)
    else
      :oauth.get(url, params, consumer, access_token, access_token_secret, stream_option)
    end
  end

  @doc """
  Send async request with post method.
  """
  def request_async(:post, url, params, consumer, access_token, access_token_secret) do
    if has_funtion(:post, 7) do
      :oauth.post(url, params, consumer, access_token, access_token_secret, stream_option, proxy_option)
    else
      :oauth.post(url, params, consumer, access_token, access_token_secret, stream_option)
    end
  end

  defp stream_option do
    [{:sync, false}, {:stream, :self}]
  end

  defp proxy_option do
    ExTwitter.Proxy.options
  end

  defp has_funtion(function, arity) do
    kv = :oauth.module_info[:exports]
         |> Enum.find(fn({k, v}) -> k == function && v == arity end)

    kv != nil
  end
end
