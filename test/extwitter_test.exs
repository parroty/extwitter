defmodule ExTwitterTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  setup_all do
    ExVCR.Config.filter_url_params(true)
    ExVCR.Config.filter_sensitive_data("oauth_signature=.+", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("guest_id=.+;", "<REMOVED>")

    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )
    :ok
  end

  test "gets authenticated user timeline" do
    use_cassette "user_timeline", custom: true do
      timeline = ExTwitter.user_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end

  test "gets specified user timeline" do
    use_cassette "user_timeline_elixirlang", custom: true do
      timeline = ExTwitter.user_timeline(screen_name: "elixirlang", count: 1)
      assert List.first(timeline).user.screen_name == "elixirlang"
    end
  end

  test "search with count param 2 (gets 2 tweet)" do
    use_cassette "search_single", custom: true do
      tweets = ExTwitter.search("test", [count: 2])
      assert Enum.count(tweets) == 2
    end
  end

  test "search with invalid count param raises error" do
    use_cassette "search_invalid_count", custom: true do
      assert_raise ExTwitter.Error, fn ->
        ExTwitter.search("test", [count: -1])
      end
    end
  end

  test "update and destroy status" do
    use_cassette "update_destroy_status", custom: true do
      tweet1 = ExTwitter.update("update sample")
      assert tweet1.text == "update sample"

      tweet2 = ExTwitter.destroy_status(tweet1.id)
      assert tweet2 != nil
    end
  end

  # gets "https://twitter.com/twitter/lists/engineering"
  test "gets list timeline" do
    use_cassette "list_timeline_twitter", custom: true do
      timeline = ExTwitter.list_timeline("engineering", "twitter", count: 1)
      assert Enum.count(timeline) == 1
      assert List.first(timeline).text != nil
    end
  end

  test "gets trend with global woeid (id: 1) returns 10 items" do
    use_cassette "trends", custom: true do
      trends = ExTwitter.trends(1)
      assert Enum.count(trends) == 10
    end
  end

  test "gets followers of twitter user" do
    use_cassette "followers", custom: true do
      followers = ExTwitter.followers("twitter", count: 1)
      assert Enum.count(followers) == 1
    end
  end
end
