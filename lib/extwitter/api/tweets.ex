defmodule ExTwitter.API.Tweets do
  @moduledoc """
  Provides Tweets API interfaces.
  """

  import ExTwitter.API.Base

  def retweets(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/retweets/#{id}.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end

  def show(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:get, "1.1/statuses/show/#{id}.json", params)
    |> ExTwitter.Parser.parse_tweet
  end

  def update(status, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([status: status] ++ options)
    request(:post, "1.1/statuses/update.json", params)
    |> ExTwitter.Parser.parse_tweet
  end

  def update_with_media(status, media_content, options \\ []) do
    encoded_media_content = Base.encode64(media_content)
    response = upload(encoded_media_content)
    update(status, [media_ids: response.media_id] ++ options)
  end

  def update_with_chunked_media(status, path, content_type, options \\ []) do
    {chunk_size, options} = Keyword.pop(options, :chunk_size, default_chunk_size())
    media_id = upload_media(path, content_type, chunk_size)
    update(status, [media_ids: media_id] ++ options)
  end

  defp upload(data, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([media: data] ++ options)
    upload_request(:post, "1.1/media/upload.json", params)
    |> ExTwitter.Parser.parse_upload
  end

  def retweet(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/statuses/retweet/#{id}.json", params)
    |> ExTwitter.Parser.parse_tweet
  end
  
  def unretweet(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/statuses/unretweet/#{id}.json", params)
    |> ExTwitter.Parser.parse_tweet
  end

  def destroy_status(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params(options)
    request(:post, "1.1/statuses/destroy/#{id}.json", params)
    |> ExTwitter.Parser.parse_tweet
  end

  def retweeter_ids(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:get, "1.1/statuses/retweeters/ids.json", params)
    |> ExTwitter.Parser.parse_ids
  end

  def lookup_status(id, options \\ []) do
    params = ExTwitter.Parser.parse_request_params([id: id] ++ options)
    request(:get, "1.1/statuses/lookup.json", params)
    |> Enum.map(&ExTwitter.Parser.parse_tweet/1)
  end
end
