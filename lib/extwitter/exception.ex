defmodule ExTwitter.Error do
  defexception [:code, :message]
end

defmodule ExTwitter.RateLimitExceededError do
  defexception [:code, :message, :reset_in, :reset_at]
end

defmodule ExTwitter.ConnectionError do
  defexception [:reason, message: "connection error"]
end
