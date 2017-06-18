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

  def user_lookup(options) when is_tuple(hd(options)) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/users/lookup.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def user_lookup(id, options \\ [])
  def user_lookup(id_or_name_list, _) when length(id_or_name_list) == 0, do: []
  def user_lookup(id_or_name_list, options) when is_list(id_or_name_list) do
    params = [
      user_id:     for(id <- id_or_name_list, is_integer(id), do: id),
      screen_name: for(name <- id_or_name_list, is_bitstring(name), do: name) ]
      |> Keyword.merge(options)
      |> ExTwitter.Parser.parse_batch_user_lookup_params
    # Should return [{"screen_name", "twitter"}]
    request(:get, "1.1/users/lookup.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_user/1)
  end

  def user_lookup(id, options) do
    user_lookup(get_id_option(id) ++ options)
  end

  def user_profile_banner(user_id) do
    request(:get, "1.1/users/profile_banner.json", parse_user_id_param(user_id))
    |> ExTwitter.Parser.parse_profile_banner
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
