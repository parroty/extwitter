defmodule ExTwitter.JSON do
  @moduledoc """
  JSON encode/decode wrapper module. It's separated to isolate the code
  affected by differences between the JSON libraries.
  """

  @doc """
  Decode json string into elixir objects.
  """
  def decode!(json) do
    Jason.decode!(json, keys: :atoms)
  end

  @doc """
  Decode json string into elixir objects.
  """
  def decode(json) do
    Jason.decode(json, keys: :atoms)
  end

  @doc """
  Get elixir object for the specified key.
  Some libraries returns as tuples, and some returns HashDict.
  """
  def get(object, key) do
    Map.get(object, key, [])
  end
end
