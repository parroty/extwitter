# elixir-json is used at the moment (jsex fails to parse sometimes).

defmodule ExTwitter.JSON do
  @moduledoc """
  JSON encode/decode wrapper module. It's separated to isolate the code
  affected by differences between the JSON libraries.
  """

  @doc """
  Decode json string into elixir objects with response verification.
  """
  def decode_and_verify(json) do
    JSON.decode!(json) |> verify_response
  end

  @doc """
  Decode json string into elixir objects.
  """
  def decode(json) do
    case JSON.decode(json) do
      {:ok, json} ->
        {:ok, json}
      error ->
        {:error, error}
    end
  end

  @doc """
  Get elixir object for the specified key.
  Some libraries returns as tuples, and some returns HashDict.
  """
  def get(object, key) do
    HashDict.get(object, key) || []
  end

  @doc """
  Parse elixir objects into lists.
  """
  def parse(object) do
    HashDict.to_list(object)
  end

  @doc """
  Verify the API request response, and raises error if response includes error response.
  """
  def verify_response(tuples) when is_record(tuples, HashDict) do
    case HashDict.fetch(tuples, "errors") do
      {:ok, details} -> raise(ExTwitter.Error, message: inspect details)
      :error -> tuples
    end
  end
  def verify_response(tuples), do: tuples
end
