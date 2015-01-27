defmodule ExTwitter.JSON do
  @moduledoc """
  JSON encode/decode wrapper module. It's separated to isolate the code
  affected by differences between the JSON libraries.
  """

  @doc """
  Decode json string into elixir objects with response verification.
  """
  def decode_and_verify(body, header) do
    verify_response(Poison.decode!(body, keys: :atoms), header)
  end

  @doc """
  Decode json string into elixir objects.
  """
  def decode(json) do
    Poison.decode(json, keys: :atoms)
  end

  @doc """
  Get elixir object for the specified key.
  Some libraries returns as tuples, and some returns HashDict.
  """
  def get(object, key) do
    Map.get(object, key, [])
  end

  @doc """
  Verify the API request response, and raises error if response includes error response.
  """
  def verify_response(body, header) do
    if is_list(body) do
      body
    else
      case Map.get(body, :errors, nil) do
        nil ->
          body
        errors when is_list(errors) ->
          parse_error(List.first(errors), header)
        error ->
          raise(ExTwitter.Error, message: inspect error)
      end
    end
  end

  defp parse_error(error, header) do
    %{:code => code, :message => message} = error
    case code do
      88 ->
        reset_at = fetch_rate_limit_reset(header)
        reset_in = Enum.max([reset_at - Timex.Date.now(:secs), 0])
        raise ExTwitter.RateLimitExceededError,
          code: code, message: message, reset_at: reset_at, reset_in: reset_in
      _  ->
        raise ExTwitter.Error, code: code, message: message
    end
  end

  defp fetch_rate_limit_reset(header) do
    {_, reset_at_in_string} = List.keyfind(header, 'x-rate-limit-reset', 0)
    {reset_at, _} = Integer.parse(to_string(reset_at_in_string))
    reset_at
  end
end
