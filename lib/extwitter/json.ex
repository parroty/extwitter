defmodule ExTwitter.JSON do
  @moduledoc """
  JSON encode/decode wrapper module. It's separated to isolate the code
  affected by differences between the JSON libraries.
  """

  @doc """
  Decode json string into elixir objects with response verification.
  """
  def decode_and_verify(json) do
    JSEX.decode!(json) |> verify_response
  end

  @doc """
  Decode json string into elixir objects.
  """
  def decode(json) do
    JSEX.decode(json)
  end

  @doc """
  Get elixir object for the specified key.
  Some libraries returns as tuples, and some returns HashDict.
  """
  def get(object, key) do
    case List.keyfind(object, key, 0, nil) do
      nil -> []
      item -> elem(item, 1)
    end
  end

  @doc """
  Parse elixir objects into lists.
  """
  def parse(object) do
    object
  end

  @doc """
  Verify the API request response, and raises error if response includes error response.
  """
  def verify_response(tuples) do
    case List.keyfind(tuples, "errors", 0, nil) do
      nil   -> tuples
      error -> raise(ExTwitter.Error, message: inspect elem(error, 1))
    end
  end
end
