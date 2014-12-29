defmodule ExTwitter.ConfigTest do
  use ExUnit.Case

  test "oauth initialization global" do
    oauth =
      [ consumer_key: "consumer_key",
        consumer_secret: "comsumer_secret",
        access_token: "access_token",
        access_token_secret: "access_token_secret" ]
    ExTwitter.Config.set(oauth)

    assert ExTwitter.Config.current_scope == :global
    assert ExTwitter.Config.get == oauth
  end

  test "oauth initialization (process)" do
    test = self
    test_fun = fn(test_pid, config) ->
      spawn(fn() ->
        ExTwitter.Config.set(:process, config)
        send(test_pid, {ExTwitter.Config.current_scope, ExTwitter.Config.get})
        exit(:normal)
      end)
    end
    test_fun.(test, [conf: :process1])
    test_fun.(test, [conf: :process2])

    assert_receive {:process, [conf: :process1]}
    assert_receive {:process, [conf: :process2]}
  end

  test "get_tuples returns list of tuples" do
    ExTwitter.Config.set([conf: "value"])
    assert ExTwitter.Config.get_tuples == [{:conf, 'value'}]
  end

  test "get_tuples returns empty list when config is not set" do
    ExTwitter.Config.set(nil)
    assert ExTwitter.Config.get_tuples == []
  end
end
