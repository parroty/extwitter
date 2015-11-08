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

  def sent_direct_messages(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/direct_messages/sent.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_direct_message/1)
  end

  def destroy_direct_message(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/direct_messages/destroy/#{id}.json", params)
    |> ExTwitter.Parser.parse_direct_message
  end

  def new_direct_message(id_or_screen_name, text) do
    params = ExTwitter.Parser.parse_request_params(get_id_option(id_or_screen_name) ++ [text: text])
    request(:post, "1.1/direct_messages/new.json", params)
    |> ExTwitter.Parser.parse_direct_message
  end
end
