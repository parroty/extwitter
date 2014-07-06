defmodule ExTwitterTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  setup_all do
    ExVCR.Config.filter_url_params(true)
    ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
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
    use_cassette "user_timeline" do
      timeline = ExTwitter.user_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end

  test "gets specified user timeline" do
    use_cassette "user_timeline_elixirlang" do
      timeline = ExTwitter.user_timeline(screen_name: "elixirlang", count: 1)
      assert List.first(timeline).user.screen_name == "elixirlang"
    end
  end

  test "gets authenticated user mentions timeline" do
    use_cassette "mentions_timeline" do
      timeline = ExTwitter.mentions_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end


  test "search with count param 2 (gets 2 tweet)" do
    use_cassette "search_single" do
      tweets = ExTwitter.search("test", [count: 2])
      assert Enum.count(tweets) == 2
    end
  end

  test "search with invalid count param raises error" do
    use_cassette "search_invalid_count" do
      assert_raise ExTwitter.Error, fn ->
        ExTwitter.search("test", [count: -1])
      end
    end
  end

  test "shows tweet" do
    use_cassette "show_tweet" do
      tweet = ExTwitter.show(446328507694845952)
      assert tweet.text =~ ~r/ship with the eunit test framework/
    end
  end

  test "update and destroy status" do
    use_cassette "update_destroy_status" do
      tweet1 = ExTwitter.update("update sample")
      assert tweet1.text == "update sample"

      tweet2 = ExTwitter.destroy_status(tweet1.id)
      assert tweet2 != nil
    end
  end

  test "gets retweeter ids" do
    use_cassette "retweeter_ids" do
      ids = ExTwitter.retweeter_ids(444144169058308096)
      assert Enum.member?(ids, 48156007)
    end
  end

  test "gets favorites" do
    use_cassette "favorites_twitter" do
      favorites = ExTwitter.favorites(screen_name: "twitter", count: 1)
      assert Enum.count(favorites) == 1
    end
  end

  test "gets lists" do
    use_cassette "lists_twitter" do
      lists = ExTwitter.lists("twitter", count: 1)
      assert Enum.count(lists) == 1
      assert List.first(lists).name =~ ~r/Twitter/
    end
  end

  test "gets list timeline" do
    use_cassette "list_timeline_twitter" do
      timeline = ExTwitter.list_timeline("engineering", "twitter", count: 1)
      assert Enum.count(timeline) == 1
      assert List.first(timeline).text != nil
    end
  end

  test "gets list membership" do
    use_cassette "list_membership" do
      lists = ExTwitter.list_memberships(screen_name: "twitter", count: 1)
      assert Enum.count(lists) == 1
      assert List.first(lists).name != nil
    end
  end

  test "gets list subscriber" do
    use_cassette "list_subscriber" do
      users = ExTwitter.list_subscribers("test", "parrotybot")
      assert Enum.count(users) == 0
    end
  end

  test "gets trend with global woeid (id: 1) returns 10 items" do
    use_cassette "trends" do
      trends = ExTwitter.trends(1)
      assert Enum.count(trends) == 10
    end
  end

  test "gets followers of twitter user" do
    use_cassette "followers" do
      followers = ExTwitter.followers("twitter", count: 1)
      assert Enum.count(followers) == 1
    end
  end

  test "gets friends of twitter user" do
    use_cassette "friends" do
      friends = ExTwitter.friends("twitter", count: 1)
      assert Enum.count(friends) == 1
    end
  end

  test "show user" do
    use_cassette "show_user" do
      user = ExTwitter.user("elixirlang", "elixirlang")
      assert user.screen_name == "elixirlang"
    end
  end

  test "search user" do
    use_cassette "search_user" do
      users = ExTwitter.user_search("elixirlang", count: 1)
      assert List.first(users).screen_name == "elixirlang"
    end
  end

  test "search geo" do
    use_cassette "search_geo" do
      geo = ExTwitter.geo_search("new_york", max_results: 1)
      assert List.first(geo).name == "New York"
    end
  end

  test "reverse geocode" do
    use_cassette "reverse_geocode" do
      geo = ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116, max_results: 1)
      assert List.first(geo).full_name == "SoMa, San Francisco"
    end
  end

end
