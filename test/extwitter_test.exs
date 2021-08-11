defmodule ExTwitterTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Httpc

  setup_all do
    ExVCR.Config.filter_url_params(true)
    ExVCR.Config.filter_sensitive_data("oauth_signature=[^\"]+", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("guest_id=.+;", "<REMOVED>")
    ExVCR.Config.filter_sensitive_data("access_token\":\".+?\"", "access_token\":\"<REMOVED>\"")

    ExTwitter.configure(
      consumer_key:        System.get_env("TWITTER_CONSUMER_KEY"),
      consumer_secret:     System.get_env("TWITTER_CONSUMER_SECRET"),
      access_token:        System.get_env("TWITTER_ACCESS_TOKEN"),
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

  test "search with metadata" do
    response1 = use_cassette "search_with_metadata_response1" do
      ExTwitter.search("test", [count: 1, search_metadata: true])
    end

    response2 = use_cassette "search_with_metadata_response2" do
      ExTwitter.search_next_page(response1.metadata)
    end

    assert Enum.count(response1.statuses) == 1
    assert Enum.count(response2.statuses) == 1
    assert List.first(response1.statuses).text != List.first(response2.statuses).text
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

  test "shows direct message" do
    use_cassette "show_direct_message" do
      direct_message = ExTwitter.direct_message(615025281712025603)
      assert direct_message.text =~ ~r/In case there are any problems with locating the place/
    end
  end

  test "gets direct messages list without options" do
    use_cassette "list_direct_messages" do
      direct_messages = ExTwitter.direct_messages
      assert Enum.count(direct_messages) == 1
      assert List.first(direct_messages).text =~ ~r/In case there are any problems with locating the place/
    end
  end

  test "gets direct messages list" do
    use_cassette "list_direct_messages" do
      direct_messages = ExTwitter.direct_messages(count: 1)
      assert Enum.count(direct_messages) == 1
      assert List.first(direct_messages).text =~ ~r/In case there are any problems with locating the place/
    end
  end

  test "gets sent direct messages list without options" do
    use_cassette "sent_direct_messages" do
      direct_messages = ExTwitter.sent_direct_messages
      assert Enum.count(direct_messages) == 1
      assert List.first(direct_messages).text =~ ~r/Please collect the samples./
    end
  end

  test "gets sent direct messages list" do
    use_cassette "sent_direct_messages" do
      direct_messages = ExTwitter.sent_direct_messages(count: 1)
      assert Enum.count(direct_messages) == 1
      assert List.first(direct_messages).text =~ ~r/Please collect the samples./
    end
  end

  test "destroy a direct message without options" do
    use_cassette "destroy_direct_message" do
      direct_message = ExTwitter.destroy_direct_message(615025281712025603)
      assert direct_message.text =~ ~r/In case there are any problems with locating the place/
    end
  end

  test "destroy a direct message with options" do
    use_cassette "destroy_direct_message" do
      direct_message = ExTwitter.destroy_direct_message(615025281712025603, include_entities: false)
      assert direct_message.text =~ ~r/In case there are any problems with locating the place/
    end
  end

  test "new direct message" do
    use_cassette "new_direct_message" do
      direct_message = ExTwitter.new_direct_message(71686163, "In case there are any problems with locating the place")
      assert direct_message.text =~ ~r/In case there are any problems with locating the place/

      direct_message = ExTwitter.new_direct_message("cmadan_", "In case there are any problems with locating the place")
      assert direct_message.text =~ ~r/In case there are any problems with locating the place/
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

  test "update and destroy status with media" do
    use_cassette "update_destroy_status_with_media" do
      image = File.read!("fixture/images/sample.png")
      tweet1 = ExTwitter.update_with_media("update sample with media", image, trim_user: true)
      assert tweet1.text =~ "update sample with media"
      assert Enum.count(tweet1.entities.media) == 1

      tweet2 = ExTwitter.destroy_status(tweet1.id)
      assert tweet2.text =~ "update sample with media"
      assert Enum.count(tweet2.entities.media) == 1
    end
  end

  test "update and destroy status with chunked media upload" do
    # NOTE: match_requests_on: [:request_body] and disabling of filtering are required for re-recording
    # Sensitive data must be manually removed from the cassette.
    use_cassette "update_destroy_status_with_chunked_media" do
      image_path = "fixture/images/sample.png"
      tweet1 = ExTwitter.update_with_chunked_media("update sample with chunked media", image_path, "image/png")
      assert tweet1.text =~ "update sample with chunked media"
      assert Enum.count(tweet1.entities.media) == 1

      tweet2 = ExTwitter.destroy_status(tweet1.id)
      assert tweet2.text =~ "update sample with chunked media"
      assert Enum.count(tweet2.entities.media) == 1
    end
  end

  test "update and destroy status with chunked media upload options" do
    # NOTE: match_requests_on: [:request_body] and disabling of filtering are required for re-recording
    # Sensitive data must be manually removed from the cassette.
    use_cassette "update_destroy_status_with_chunked_media_options" do
      image_path = "fixture/images/sample.png"
      tweet1 = ExTwitter.update_with_chunked_media("update sample with chunked media", image_path, "image/png", trim_user: true, chunked_size: 131_072)
      assert tweet1.text =~ "update sample with chunked media"
      assert Enum.count(tweet1.entities.media) == 1

      tweet2 = ExTwitter.destroy_status(tweet1.id)
      assert tweet2.text =~ "update sample with chunked media"
      assert Enum.count(tweet2.entities.media) == 1
    end
  end

  test "retweet and unretweet status" do
    use_cassette "retweet_unretweet_status" do
      # https://twitter.com/twitter/statuses/589095997340405760
      sample_tweet_id = 589095997340405760

      tweet1 = ExTwitter.retweet(sample_tweet_id, trim_user: true)
      assert tweet1.text =~ "RT @Twitter:"

      tweet2 = ExTwitter.unretweet(tweet1.id, trim_user: true)
      assert tweet2.text =~ "Please read our updated Terms"
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

  test "create favorite" do
    use_cassette "create_favorite_twitter" do
      id = 243138128959913986
      tweet = ExTwitter.create_favorite(id, [])
      assert tweet.id == id
    end
  end

  test "destroy favorite" do
    use_cassette "destroy_favorite_twitter" do
      id = 243138128959913986
      tweet = ExTwitter.destroy_favorite(id, [])
      assert tweet.id == id
    end
  end

  test "gets lists by screen_name" do
    use_cassette "lists_twitter" do
      lists = ExTwitter.lists("twitter", count: 1)
      assert Enum.count(lists) == 1
      assert List.first(lists).name =~ ~r/Twitter/
    end
  end

  test "gets lists by user_id" do
    use_cassette "lists_twitter" do
      lists = ExTwitter.lists(783214, count: 1)
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
  
  test "creates list" do
    use_cassette "create_list" do
      new_list = ExTwitter.create_list("New List")
      assert new_list.name == "New List"
    end
  end

  test "destroys list" do
    use_cassette "destroy_list" do
      list = ExTwitter.create_list("New List")
      destroyed_list = ExTwitter.destroy_list(list.id)
      assert destroyed_list.id == list.id
    end
  end

  test "gets trend with global woeid (id: 1) returns 10 items" do
    use_cassette "trends" do
      trends = ExTwitter.trends(1)
      assert Enum.count(trends) == 10
    end
  end

  test "gets followers of twitter user by screen_name" do
    use_cassette "followers" do
      followers_cursor = ExTwitter.followers("twitter", count: 1)
      assert Enum.count(followers_cursor.items) == 1
    end
  end

  test "gets followers of twitter user by user_id" do
    use_cassette "followers" do
      followers_cursor = ExTwitter.followers(783214, count: 1)
      assert Enum.count(followers_cursor.items) == 1
    end
  end

  test "gets follower ids of twitter user by screen_name" do
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

  test "follow and unfollow user" do
    use_cassette "follow_unfollow_user" do
      user1 = ExTwitter.follow("twitter")
      assert user1.screen_name == "twitter"

      user2 = ExTwitter.unfollow("twitter")
      assert user2.screen_name == "twitter"
    end
  end

  test "gets friends of twitter user by screen_name" do
    use_cassette "friends" do
      friends_cursor = ExTwitter.friends("twitter", count: 1)
      assert Enum.count(friends_cursor.items) == 1
    end
  end

  test "gets friends of twitter user by user_id" do
    use_cassette "friends" do
      friends_cursor = ExTwitter.friends(783214, count: 1)
      assert Enum.count(friends_cursor.items) == 1
    end
  end

  test "gets friend ids of twitter user by screen_name" do
    use_cassette "friend_ids" do
      friend_ids_cursor = ExTwitter.friend_ids("twitter", count: 1)
      assert Enum.count(friend_ids_cursor.items) == 1
    end
  end

  test "gets friend ids of twitter user by user_id" do
    use_cassette "friend_ids" do
      friend_ids_cursor = ExTwitter.friend_ids(783214, count: 1)
      assert Enum.count(friend_ids_cursor.items) == 1
    end
  end

  test "gets credentials" do
    use_cassette "verify_credentials", custom: true do
      user = ExTwitter.verify_credentials
      assert user.id != nil
      assert user.screen_name != nil
    end
  end

  test "block and unblock user by screen_name" do
    use_cassette "blocks" do
      user1 = ExTwitter.block("twitter")
      assert user1.screen_name == "Twitter"
      user2 = ExTwitter.unblock("twitter")
      assert user2.screen_name == "Twitter"
    end
  end

  test "block and unblock user by user_id" do
    use_cassette "blocks" do
      user1 = ExTwitter.block(783214)
      assert user1.screen_name == "Twitter"
      user2 = ExTwitter.unblock(783214)
      assert user2.screen_name == "Twitter"
    end
  end

  test "lookup user by screen_name" do
    use_cassette "lookup_user" do
      users = ExTwitter.user_lookup("twitter")
      assert Enum.count(users) == 1
      assert Enum.at(users, 0).screen_name == "twitter"
    end
  end

  test "lookup user by user_id" do
    use_cassette "lookup_user" do
      users = ExTwitter.user_lookup(783214)
      assert Enum.count(users) == 1
      assert Enum.at(users, 0).screen_name == "twitter"
    end
  end

  test "lookup user by screen_name using options" do
    use_cassette "lookup_user" do
      users = ExTwitter.user_lookup(screen_name: "twitter")
      assert Enum.count(users) == 1
      assert Enum.at(users, 0).screen_name == "twitter"
    end
  end

  test "lookup users by user_id" do
    use_cassette "lookup_users" do
      users = ExTwitter.user_lookup([783214, 10230812, 507309896])
      assert Enum.count(users) == 3
      assert Enum.at(users, 0).screen_name == "Twitter"
      assert Enum.at(users, 1).screen_name == "josevalim"
      assert Enum.at(users, 2).screen_name == "elixirlang"
    end
  end

  test "lookup users by screen_name" do
    use_cassette "lookup_users" do
      users = ExTwitter.user_lookup(["twitter", "josevalim", "elixirlang"])
      assert Enum.count(users) == 3
      assert Enum.at(users, 0).screen_name == "Twitter"
      assert Enum.at(users, 1).screen_name == "josevalim"
    end
  end

  test "lookup users by screen_name along with options" do
    use_cassette "lookup_users" do
      users = ExTwitter.user_lookup(["twitter", "josevalim", "elixirlang"], include_entities: false)
      assert Enum.count(users) == 3
      assert Enum.at(users, 0).screen_name == "Twitter"
      assert Enum.at(users, 1).screen_name == "josevalim"
    end
  end

  test "lookup users by user_id along with options" do
    use_cassette "lookup_users" do
      users = ExTwitter.user_lookup([783214, 10230812, 507309896], include_entities: false)
      assert Enum.count(users) == 3
      assert Enum.at(users, 0).screen_name == "Twitter"
      assert Enum.at(users, 1).screen_name == "josevalim"
    end
  end

  test "lookup users with empty list returns nil" do
    use_cassette "lookup_users" do
      users = ExTwitter.user_lookup([], include_entities: false)
      assert length(users) == 0
    end
  end

  test "get profile banners by user_id" do
    use_cassette "user_profile_banner" do
      profile_banner = ExTwitter.user_profile_banner(783214)
      assert profile_banner.sizes.web.h > 0
      assert profile_banner.sizes.web.w > 0
    end
  end

  test "get profile banners by screen_name" do
    use_cassette "user_profile_banner" do
      profile_banner = ExTwitter.user_profile_banner("twitter")
      assert profile_banner.sizes.web.h > 0
      assert profile_banner.sizes.web.w > 0
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

  test "lookup friendship" do
    use_cassette "lookup_friendship" do
      [relationship] = ExTwitter.friends_lookup("tpope")
      assert relationship.connections == ["following"]
    end
  end

  test "rate limit exceed" do
    use_cassette "rate_limit_exceed", custom: true do
      assert_raise ExTwitter.RateLimitExceededError, fn ->
        ExTwitter.follower_ids("twitter", count: 1)
      end
    end
  end

  test "request token" do
    use_cassette "request_token" do
      # Fetching request token with which to generate authenticate or authorize requests
      t = ExTwitter.request_token()
      assert t != nil
      assert t.oauth_token != nil
      assert t.oauth_token_secret != nil
      assert t.oauth_callback_confirmed != nil
    end
  end

  test "generate authorize url" do
    # Check generated oauth authorize url against twitter url pattern
    # Validating the URL actually works is essentially a manual test
    token = "some_token"
    {:ok, regex} = Regex.compile("^https://api.twitter.com/oauth/authorize\\?oauth_token=" <> token)

    {:ok, authorize_url} = ExTwitter.authorize_url(token)

    assert Regex.match?(regex, authorize_url)
  end

  test "generate authenticate url" do
    # Check generated oauth authenticate url against twitter url pattern
    # Validating the URL actually works is essentially a manual test
    token = "some_token"
    {:ok, regex} = Regex.compile("^https://api.twitter.com/oauth/authenticate\\?oauth_token=" <> token)

    {:ok, authenticate_url} = ExTwitter.authenticate_url(token)

    assert Regex.match?(regex, authenticate_url)
  end

  test "validate access token" do
    use_cassette "access_token", custom: true do
      verifier = "yep its true"
      request_token = "pls"

      {:ok, access_token} = ExTwitter.access_token(verifier, request_token)

      assert access_token != nil
      assert access_token.oauth_token != nil
      assert access_token.oauth_token != nil
      assert access_token.user_id == "28487251"
      assert access_token.screen_name == "julianobs"
    end
  end

  test "failed connection" do
    use_cassette "failed_connection", custom: true do
      assert_raise ExTwitter.ConnectionError, "connection error", fn ->
        ExTwitter.follower_ids("twitter", count: 1)
      end
    end
  end
end
