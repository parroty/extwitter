defmodule ExTwitter.JSON do
  @moduledoc """
  JSON encode/decode wrapper module.

  It's separated to isolate the code affected by differences between the JSON
  libraries.
  """

  @doc """
  Decode JSON string into Elixir objects.
  """
  def decode!(json) do
    json_library().decode!(json, keys: :atoms)
  end

  @doc """
  Decode JSON string into Elixir objects.
  """
  def decode(json) do
    json_library().decode(json, keys: :atoms)
  end

  @doc """
  Get Elixir object for the specified key.

  Some libraries returns as tuples or HashDict.
  """
  def get(object, key) do
    Map.get(object, key, [])
  end

  defp json_library do
    Application.get_env(:extwitter, :json_library, Jason)
  end
end
