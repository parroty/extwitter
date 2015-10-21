defmodule ExTwitter.Config do
  def current_scope do
    if Process.get(:_ex_twitter_oauth, nil), do: :process, else: :global
  end

  @doc """
  Get OAuth configuration values.
  """
  def get, do: get(current_scope)
  def get(:global) do
    Application.get_env(:extwitter, :oauth, nil) ||
    Application.get_env(:ex_twitter, :oauth, nil)
  end
  def get(:process), do: Process.get(:_ex_twitter_oauth, nil)

  @doc """
  Set OAuth configuration values.
  """
  def set(value), do: set(current_scope, value)
  def set(:global, value), do: Application.put_env(:extwitter, :oauth, value)
  def set(:process, value) do
    Process.put(:_ex_twitter_oauth, value)
    :ok
  end

  @doc """
  Get OAuth configuration values in tuple format.
  """
  def get_tuples do
    case ExTwitter.Config.get do
      nil -> []
      tuples -> tuples |> Enum.map(fn({k, v}) -> {k, to_char_list(v)} end)
    end
  end
end
