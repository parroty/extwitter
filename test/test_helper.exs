ExUnit.start

defmodule TestHelper.TestStore do
  @ets_table :extwitter_teststore
  @ets_key :config_key

  def start do
    if :ets.info(@ets_table) == :undefined do
      :ets.new(@ets_table, [:set, :public, :named_table])
    end
    :ok
  end

  def get do
    :ets.lookup(@ets_table, @ets_key)[@ets_key] || []
  end

  def set(value) do
    :ets.insert(@ets_table, {@ets_key, value})
    value
  end
end
