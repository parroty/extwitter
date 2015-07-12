defmodule ExTwitterTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  setup_all do
    ExVCR.Config.filter_url_params(true)
    ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("guest_id=.+;", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("access_token\":\".+?\"", "access_token\":\"<REMOVED>\"")

    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret: System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
    )

    :ok
  end

  test "gets current configuration" do
    config = ExTwitter.configure
    assert Keyword.has_key?(config, :consumer_key)
    assert Keyword.has_key?(config, :consumer_secret)
    assert Keyword.has_key?(config, :access_token)
    assert Keyword.has_key?(config, :access_token_secret)
  end

  test "sends request method to search method" do
    use_cassette "base_request" do
      response = ExTwitter.request(:get, "1.1/search/tweets.json", [q: "elixir", count: 1])
      tweets = ExTwitter.JSON.get(response, :statuses) |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
      assert Enum.count(tweets) == 1
    end
  end

  test "gets authenticated user's mentions timeline" do
    use_cassette "mentions_timeline" do
      timeline = ExTwitter.mentions_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end

  test "gets authenticated user's timeline" do
    use_cassette "user_timeline" do
      timeline = ExTwitter.user_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end

  test "gets specified user's timeline" do
    use_cassette "user_timeline_elixirlang" do
      timeline = ExTwitter.user_timeline(screen_name: "elixirlang", count: 1)
      assert List.first(timeline).user.screen_name == "elixirlang"
    end
  end

  test "search with count param 2 (gets 2 tweet)" do
    use_cassette "search_single" do
      tweets = ExTwitter.search("test", count: 2)
      assert Enum.count(tweets) == 2
    end
  end

  test "gets authenticated user's home timeline" do
    use_cassette "home_timeline" do
      timeline = ExTwitter.home_timeline(count: 1)
      assert Enum.count(timeline) == 1
    end
  end

  test "gets authenticated user's retweets of me" do
    use_cassette "retweets_of_me" do
      timeline = ExTwitter.retweets_of_me
      assert Enum.count(timeline) == 0  # testing user doesn't have retweets
    end
  end

  test "search with invalid count param raises error" do
    use_cassette "search_invalid_count" do
      assert_raise ExTwitter.Error, fn ->
        ExTwitter.search("test", count: -1)
      end
    end
  end

  test "shows retweets" do
    use_cassette "retweets" do
      retweets = ExTwitter.retweets(444144169058308096, count: 1)
      Enum.count(retweets) == 1
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
      assert tweet2.text == "update sample"
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
      lists = ExTwitter.list_memberships(screen_name: "twitter", count: 2)
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

  test "gets list member" do
    use_cassette "list_member" do
      users = ExTwitter.list_members("test", "parrotybot")
      assert List.first(users).name == "Elixir Fountain"
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
      followers_cursor = ExTwitter.followers("twitter", count: 1)
      assert Enum.count(followers_cursor.items) == 1
    end
  end

  test "gets follower ids of twitter user" do
    use_cassette "follower_ids" do
      follower_ids_cursor = ExTwitter.follower_ids("twitter", count: 1)
      assert Enum.count(follower_ids_cursor.items) == 1
    end
  end

  test "gets follower ids of twitter user by user_id" do
    use_cassette "follower_ids" do
      follower_ids_cursor = ExTwitter.follower_ids(783214, count: 1)
      assert Enum.count(follower_ids_cursor.items) == 1
    end
  end

  test "gets friends of twitter user" do
    use_cassette "friends" do
      friends_cursor = ExTwitter.friends("twitter", count: 1)
      assert Enum.count(friends_cursor.items) == 1
    end
  end

  test "gets friend ids of twitter user" do
    use_cassette "friend_ids" do
      friend_ids_cursor = ExTwitter.friend_ids("twitter", count: 1)
      assert Enum.count(friend_ids_cursor.items) == 1
    end
  end

  test "lookup user" do
    use_cassette "lookup_user" do
      users = ExTwitter.user_lookup("twitter")
      assert Enum.count(users) == 1
      assert Enum.at(users, 0).screen_name == "twitter"
    end
  end

  test "show user" do
    use_cassette "show_user" do
      user = ExTwitter.user("elixirlang")
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
      geo = ExTwitter.geo_search("new york", max_results: 1)
      assert List.first(geo).name == "New York"
    end
  end

  test "reverse geocode" do
    use_cassette "reverse_geocode" do
      geo = ExTwitter.reverse_geocode(37.7821120598956, -122.400612831116, max_results: 1)
      assert List.first(geo).full_name =~ "San Francisco"
    end
  end

  test "rate limit status" do
    use_cassette "rate_limit_status" do
      status = ExTwitter.rate_limit_status(resources: "statuses")
      assert status[:resources][:statuses][:"/statuses/home_timeline"][:limit] > 0
      assert status[:rate_limit_context][:access_token] == "<REMOVED>"
    end
  end

  test "lookup status" do
    # Fetching the following tweets as sample data.
    #   https://twitter.com/twitter/status/504692034473435136
    #   https://twitter.com/twitter/status/502883389347622912
    use_cassette "lookup_status" do
      tweets = ExTwitter.lookup_status("504692034473435136,502883389347622912")
      assert Enum.count(tweets) == 2
      assert Enum.at(tweets, 0).text =~ ~r/Want to know how your/
      assert Enum.at(tweets, 1).text =~ ~r/Honored to be named/
    end
  end

  test "rate limit exceed" do
    use_cassette "rate_limit_exceed", custom: true do
      assert_raise ExTwitter.RateLimitExceededError, fn ->
        ExTwitter.follower_ids("twitter", count: 1)
      end
    end
  end
end
