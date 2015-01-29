defmodule ExTwitter.JSON.Bench do
  use Benchfella
  @mock_tweet_json File.read!("fixture/mocks/tweet.json")

  bench "decode" do
    ExTwitter.JSON.decode(@mock_tweet_json)
  end
end

defmodule ExTwitter.Parser.Bench do
  use Benchfella
  @mock_tweet_json File.read!("fixture/mocks/tweet.json")

  bench "parse_tweet", [tweet: decode_json()] do
    ExTwitter.Parser.parse_tweet(tweet)
  end

  defp decode_json do
    {:ok, tweet} = ExTwitter.JSON.decode(@mock_tweet_json)
    tweet
  end
end
