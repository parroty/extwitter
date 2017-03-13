defmodule ExTwitter.API.Blocks do
  @moduledoc """
  Provides user blocking API interfaces.
  """

  import ExTwitter.API.Base

  def block(id) do
    params = ExTwitter.Parser.parse_request_params(get_id_option(id))
    request(:post, "1.1/blocks/create.json", params)
    |> ExTwitter.Parser.parse_user
  end

  def unblock(id) do
    params = ExTwitter.Parser.parse_request_params(get_id_option(id))
    request(:post, "1.1/blocks/destroy.json", params)
    |> ExTwitter.Parser.parse_user
  end
end
