defmodule ExTwitter.Store do
  @moduledoc """
  An module to store the configuration settings.
  """

  @ets_table :extwitter_setting

  @doc """
  Initialize configuration table.
  """
  def setup do
    if :ets.info(@ets_table) == :undefined do
      :ets.new(@ets_table, [:set, :public, :named_table])
    end
  end

  @doc """
  Get setting value for the specified key.
  """
  def get(key) do
    setup
    :ets.lookup(@ets_table, key)[key]
  end

  @doc """
  Set setting value for the specified key.
  """
  def set(key, value) do
    setup
    :ets.insert(@ets_table, {key, value})
    :ok
  end
end
