defmodule ExTwitter.API.Users do
  @moduledoc """
  Provides users API interfaces.
  """

  import ExTwitter.API.Base

  def verify_credentials(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/account/verify_credentials.json", params)
    |> ExTwitter.Parser.parse_user
  end

  def user_lookup(options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/users/lookup.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def user_lookup(id, options \\ []) do
    user_lookup(get_id_option(id) ++ options)
  end

  def user_search(query, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([q: query] ++ options)
    request(:get, "1.1/users/search.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def user(user_id) do
    user(user_id, [])
  end

  def user(user_id, options) when is_list(options) do
    params = ExTwitter.Parser.parse_request_params(parse_user_id_param(user_id) ++ options)
    request(:get, "1.1/users/show.json", params)
    |> ExTwitter.Parser.parse_user
  end


  defp parse_user_id_param(user_id) when is_integer(user_id) do
    [user_id: user_id]
  end

  defp parse_user_id_param(screen_name) do
    [screen_name: screen_name]
  end

  # TODO: deprecated method
  def user(user_id, screen_name, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([user_id: user_id, screen_name: screen_name] ++ options)
    request(:get, "1.1/users/show.json", params)
    |> ExTwitter.Parser.parse_user
  end
end
