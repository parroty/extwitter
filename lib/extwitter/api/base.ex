defmodule ExTwitter.API.Base do
  @moduledoc """
  Provides basic and common functionalities for Twitter API.
  """

  @doc """
  Send API request to the twitter server.
  """
  def request(method, path, params \\ []) do
    oauth = ExTwitter.Config.get_tuples |> verify_params
    consumer = {oauth[:consumer_key], oauth[:consumer_secret], :hmac_sha1}
    ExTwitter.OAuth.request(method, request_url(path), params, consumer, oauth[:access_token], oauth[:access_token_secret])
      |> parse_result
  end

  def verify_params([]) do
    raise ExTwitter.Error.new(
      message: "OAuth parameters are not set. Use ExTwitter.Configure function to set parameters in advance.")
  end
  def verify_params(params), do: params

  defp request_url(path) do
    "https://api.twitter.com/#{path}" |> to_char_list
  end

  defp parse_result(result) do
    {:ok, {_response, _header, body}} = result
    to_string(body) |> ExTwitter.JSON.decode_and_verify
  end
end
