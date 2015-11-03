defmodule ExTwitter.API.DirectMessages do
  @moduledoc """
  Provides Direct Messages API interfaces.
  """

  import ExTwitter.API.Base

  def direct_message(id) do
    request(:get, "1.1/direct_messages/show/#{id}.json")
    |> ExTwitter.Parser.parse_direct_message
  end

  def direct_messages(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/direct_messages.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_direct_message/1)
  end
end
