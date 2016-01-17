defmodule ExTwitter.ProxyTest do
  use ExUnit.Case

  alias ExTwitter.Proxy

  @server "www-proxy.mycompany.com"
  @user "user"
  @password "password"

  test "get_proxy_option with port number in binary" do
    env = [server: @server, port: "8000", user: @user, password: @password]
    option = Proxy.get_proxy_option(env)

    assert option == [{:proxy, {{'www-proxy.mycompany.com', 8000}, []}}]
  end

  test "get_proxy_option with integer port in integer" do
    env = [server: @server, port: 8000, user: @user, password: @password]
    option = Proxy.get_proxy_option(env)

    assert option == [{:proxy, {{'www-proxy.mycompany.com', 8000}, []}}]
  end

  test "get_proxy_option with invalid port throws error" do
    env = [server: @server, port: "abc", user: @user, password: @password]

    assert_raise ExTwitter.Error, fn ->
      Proxy.get_proxy_option(env)
    end
  end

  test "get_proxy_option with empty parameter returns empty" do
    env = []
    option = Proxy.get_proxy_option(env)

    assert option == []
  end

  test "get_auth_option with valid parameters" do
    env = [server: @server, port: "8000", user: @user, password: @password]
    option = Proxy.get_auth_option(env)

    assert option == [{:proxy_auth, {'user', 'password'}}]
  end

  test "get_auth_option with empty parameters returns empty" do
    env = []
    option = Proxy.get_auth_option(env)

    assert option == []
  end
end