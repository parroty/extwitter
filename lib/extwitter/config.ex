defmodule ExTwitter.Config do
  @moduledoc """
  Provide OAuth configuration settings.
  """

  @setting_key :extwitter_oauth

  @doc """
  Set OAuth configuration values.
  """
  def set(values) do
    ExTwitter.Store.set(@setting_key, values)
  end

  @doc """
  Get OAuth configuration values.
  """
  def get do
    ExTwitter.Store.get(@setting_key)
  end

  @doc """
  Get OAuth configuration values in tuple format.
  """
  def get_tuples(nil) do
    [ consumer_key: "nil", consumer_secret: "nil",
      access_token: "nil", access_token_secret: "nil" ]
  end
  def get_tuples do
    get |> Enum.map(fn({k, v}) -> {k, String.to_char_list!(v)} end)
  end
end