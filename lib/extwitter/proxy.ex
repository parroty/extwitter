defmodule ExTwitter.Proxy do
  @moduledoc """
  Provide helper functions for proxy setting.
  """

  @doc """
  Initialize proxy settings based on defintion in config.exs.
  """
  def initialize do
    if proxy != nil do
      :httpc.set_options(get_proxy_option(proxy))
    end
  end

  @doc """
  Get proxy settings for sending request based on definition in config.exs.
  """
  def options do
    if proxy != nil do
      get_auth_option(proxy)
    else
      []
    end
  end

  def get_proxy_option(proxy) do
    if proxy[:server] != nil && proxy[:port] != nil do
      server = String.to_char_list(proxy[:server])
      port = parse_port(proxy[:port])
      [{:proxy, {{server, port}, []}}]
    else
      []
    end
  end

  def get_auth_option(proxy) do
    if proxy[:user] != nil && proxy[:password] != nil do
      user = String.to_char_list(proxy[:user])
      password = String.to_char_list(proxy[:password])
      [{:proxy_auth, {user, password}}]
    else
      []
    end
  end

  defp proxy do
    Application.get_env(:extwitter, :proxy, nil)
  end

  defp parse_port(port) when is_binary(port) do
    case Integer.parse(port) do
      {integer, _binary} ->
        integer
      :error ->
        raise %ExTwitter.Error{
          message: "Failed to parse :port for proxy as integer (port: #{port})"
        }
    end
  end
  defp parse_port(port), do: port
end