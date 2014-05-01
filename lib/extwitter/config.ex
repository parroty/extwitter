defmodule ExTwitter.Config do
  @moduledoc """
  Provide OAuth configuration settings.
  """

  @setting_key :extwitter_oauth

  def start do
    ExTwitter.Store.set(@setting_key, [])
  end

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
  def get_tuples do
    ExTwitter.Config.get |> Enum.map(fn({k, v}) -> {k, to_char_list(v)} end)
  end
end