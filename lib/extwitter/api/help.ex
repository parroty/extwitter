defmodule ExTwitter.API.Help do
  @moduledoc """
  Provides help API interfaces.
  """

  import ExTwitter.API.Base

  def rate_limit_status(options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/application/rate_limit_status.json", params)
  end
end
