defmodule ExTwitter.API.Streaming.Parse.Bench do
  use Benchfella
  import ExTwitter.API.Streaming

  @mock_tweet_json File.read!("fixture/mocks/tweet.json")
  @mock_limit_json File.read!("fixture/mocks/limit.json")

  bench "parse_tweet_message(tweet)" do
    parse_tweet_message(@mock_tweet_json, receive_messages: true)
  end

  bench "parse_tweet_message(control)" do
    parse_tweet_message(@mock_limit_json, receive_messages: true)
  end

end
