defmodule ExTwitterStreamTest do
  use ExUnit.Case, async: false
  import Mock

  @mock_tweet_json "{\"created_at\":\"Wed Mar 19 16:53:03 +0000 2014\",\"id\":446328507694845952,\"id_str\":\"446328507694845952\",\"text\":\"sample tweet text\",\"source\":\"web\",\"truncated\":false,\"in_reply_to_status_id\":446225539796594688,\"in_reply_to_status_id_str\":\"446225539796594688\",\"in_reply_to_user_id\":86202207,\"in_reply_to_user_id_str\":\"86202207\",\"in_reply_to_screen_name\":\"suranyami\",\"user\":{\"id\":507309896,\"id_str\":\"507309896\",\"name\":\"Elixir Lang\",\"screen_name\":\"elixirlang\",\"location\":\"\",\"description\":\"The Elixir programming language that runs on the Erlang VM\",\"url\":\"http:\\/\\/t.co\\/xGmHND9luN\",\"entities\":{\"url\":{\"urls\":[{\"url\":\"http:\\/\\/t.co\\/xGmHND9luN\",\"expanded_url\":\"http:\\/\\/elixir-lang.org\",\"display_url\":\"elixir-lang.org\",\"indices\":[0,22]}]},\"description\":{\"urls\":[]}},\"protected\":false,\"followers_count\":2408,\"friends_count\":6,\"listed_count\":68,\"created_at\":\"Tue Feb 28 12:31:32 +0000 2012\",\"favourites_count\":31,\"utc_offset\":3600,\"time_zone\":\"Amsterdam\",\"geo_enabled\":false,\"verified\":false,\"statuses_count\":370,\"lang\":\"en\",\"contributors_enabled\":false,\"is_translator\":false,\"is_translation_enabled\":false,\"profile_background_color\":\"131516\",\"profile_background_image_url\":\"http:\\/\\/abs.twimg.com\\/images\\/themes\\/theme14\\/bg.gif\",\"profile_background_image_url_https\":\"https:\\/\\/abs.twimg.com\\/images\\/themes\\/theme14\\/bg.gif\",\"profile_background_tile\":true,\"profile_image_url\":\"http:\\/\\/pbs.twimg.com\\/profile_images\\/1859982753\\/drop_normal.png\",\"profile_image_url_https\":\"https:\\/\\/pbs.twimg.com\\/profile_images\\/1859982753\\/drop_normal.png\",\"profile_link_color\":\"009999\",\"profile_sidebar_border_color\":\"EEEEEE\",\"profile_sidebar_fill_color\":\"EFEFEF\",\"profile_text_color\":\"333333\",\"profile_use_background_image\":true,\"default_profile\":false,\"default_profile_image\":false,\"following\":false,\"follow_request_sent\":false,\"notifications\":false},\"geo\":null,\"coordinates\":null,\"place\":null,\"contributors\":null,\"retweet_count\":0,\"favorite_count\":0,\"entities\":{\"hashtags\":[],\"symbols\":[],\"urls\":[],\"user_mentions\":[{\"screen_name\":\"suranyami\",\"name\":\"Ravey Day-V Gravy\",\"id\":86202207,\"id_str\":\"86202207\",\"indices\":[0,10]}]},\"favorited\":false,\"retweeted\":false,\"lang\":\"en\"}\r\n"
  @mock_limit_json "{\"limit\":{\"timestamp_ms\":\"1415022747749\",\"track\":542}}\r\n"
  @mock_deleted_tweet "{\"delete\":{\"status\":{\"id\":1234,\"id_str\":\"1234\",\"user_id\":3,\"user_id_str\":\"3\"}}}\r\n"
  @mock_stall_warning "{\"warning\":{\"code\":\"FALLING_BEHIND\",\"message\":\"Your connection is falling behind and messages are being queued for delivery to you. Your queue is now over 60% full. You will be disconnected when the queue is full.\",\"percent_full\":60}}\r\n"

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
    TestHelper.TestStore.start
    :ok
  end

  setup do
    TestHelper.TestStore.set([])
    :ok
  end

  test_with_mock "gets twetter sample stream", :oauth,
    [get: fn(_url, _params, _consumer, _access_token, _access_token_secret, _options) ->
      request_id = make_ref
      TestHelper.TestStore.set({self, request_id})
      {:ok, request_id}
    end] do

    stream = ExTwitter.stream_sample

    wait_async_request_initialization
    send_mock_data(TestHelper.TestStore.get, @mock_tweet_json)

    tweet = Enum.take(stream, 1) |> List.first
    assert tweet.text =~ ~r/sample tweet text/
  end

  test_with_mock "gets twetter filter stream", :oauth,
    [post: fn(_url, _params, _consumer, _access_token, _access_token_secret, _options) ->
      request_id = make_ref
      TestHelper.TestStore.set({self, request_id})
      {:ok, request_id}
    end] do

    # initiate processing
    stream = ExTwitter.stream_filter(follow: "twitter")

    # send mock data
    wait_async_request_initialization
    send_mock_data(TestHelper.TestStore.get, @mock_tweet_json)

    # verify response
    tweet = Enum.take(stream, 1) |> List.first
    assert tweet.text =~ ~r/sample tweet text/
  end

  test_with_mock "gets twitter stream messages", :oauth,
      [post: fn(_url, _params, _consumer, _access_token, _access_token_secret, _options) ->
      request_id = make_ref
      TestHelper.TestStore.set({self, request_id})
      {:ok, request_id}
    end] do

    # initiate processing
    stream = ExTwitter.stream_filter(track: "twitter", receive_messages: true)

    # send mock data
    wait_async_request_initialization
    send_mock_data(TestHelper.TestStore.get, @mock_limit_json)
    send_mock_data(TestHelper.TestStore.get, @mock_deleted_tweet)
    send_mock_data(TestHelper.TestStore.get, @mock_stall_warning)

    [limit, deleted_tweet, stall_warning] = Enum.take(stream, 3)
    assert limit.track == 542
    assert deleted_tweet.status["id"] == 1234
    assert stall_warning.code == "FALLING_BEHIND"
  end

  test "stream control succeeds" do
    parent = self
    pid = spawn(fn ->
      receive do
        {:control_stop, _pid} -> send parent, :ok
      after
        50 -> :timeout
      end
    end)

    assert ExTwitter.stream_control(pid, :stop, timeout: 50) == :ok
  end

  test "stream control timeouts after 10 milliseconds" do
    assert ExTwitter.stream_control(self, :stop, timeout: 10) == :timeout
  end

  defp wait_async_request_initialization do
    :timer.sleep(100) # put small wait
  end

  defp send_mock_data({pid, request_id}, json) do
    headers = [{'connection', 'close'}, {'date', 'Sun, 06 Jul 2014 14:48:13 UTC'},
               {'transfer-encoding', 'chunked'}, {'content-type', 'application/json'},
               {'x-connection-hash', '4be738c31e867bd602893fb3a320e55e'}]


    send pid, {:http, {request_id, :stream_start, headers}}
    send pid, {:http, {request_id, :stream, json}}
  end
end

