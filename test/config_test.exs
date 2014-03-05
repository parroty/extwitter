defmodule ExTwitter.ConfigTest do
  use ExUnit.Case

  test "oauth initialization" do
    oauth =
      [ consumer_key: "consumer_key",
        consumer_secret: "comsumer_secret",
        access_token: "access_token",
        access_token_secret: "access_token_secret" ]
    ExTwitter.Config.set(oauth)

    assert ExTwitter.Config.get == oauth
  end
end
