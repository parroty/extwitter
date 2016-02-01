defmodule ExTwitter.Model.Tweet do
  @moduledoc """
  Tweet object.

  ## Reference
  https://dev.twitter.com/overview/api/tweets
  """
  defstruct contributors: nil, coordinates: nil, created_at: nil,
    current_user_retweet: nil, entities: nil, extended_entities: nil, favorite_count: nil,
    favorited: nil, filter_level: nil, geo: nil, id: nil, id_str: nil,
    in_reply_to_screen_name: nil, in_reply_to_status_id: nil,
    in_reply_to_status_id_str: nil, in_reply_to_user_id: nil,
    in_reply_to_user_id_str: nil, lang: nil, place: nil,
    possibly_sensitive: nil, quoted_status_id: nil,
    quoted_status_id_str: nil, quoted_status: nil, scopes: nil,
    retweet_count: nil, retweeted: nil, retweeted_status: nil,
    source: nil, text: nil, truncated: nil, user: nil,
    withheld_copyright: nil, withheld_in_countries: nil,
    withheld_scope: nil
  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Upload do
  defstruct expires_after_secs: nil,  media_id: nil, media_id_string: nil, size: nil
  @type t :: %__MODULE__{}
end


defmodule ExTwitter.Model.User do
  @moduledoc """
  User object.

  ## Reference
  https://dev.twitter.com/overview/api/users
  """
  defstruct contributors_enabled: nil, created_at: nil,
    default_profile: nil, default_profile_image: nil, description: nil,
    entities: nil, favourites_count: nil, follow_request_sent: nil,
    followers_count: nil, following: nil, friends_count: nil,
    geo_enabled: nil, id: nil, id_str: nil, is_translation_enabled: nil,
    is_translator: nil, lang: nil, listed_count: nil, location: nil,
    name: nil, notifications: nil, profile_background_color: nil,
    profile_background_image_url: nil,
    profile_background_image_url_https: nil, profile_background_tile: nil,
    profile_banner_url: nil, profile_image_url: nil,
    profile_image_url_https: nil, profile_link_color: nil,
    profile_sidebar_border_color: nil, profile_sidebar_fill_color: nil,
    profile_text_color: nil, profile_use_background_image: nil,
    protected: nil, screen_name: nil, show_all_inline_media: nil,
    status: nil, statuses_count: nil, time_zone: nil, url: nil,
    utc_offset: nil, verified: nil, withheld_in_countries: nil,
    withheld_scope: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.DirectMessage do
  defstruct created_at: nil, entities: nil, id: nil, id_str: nil,
    recipient: nil, recipient_id: nil, recipient_screen_name: nil,
    sender: nil, sender_id: nil, sender_screen_name: nil, text: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Entities do
  @moduledoc """
  Entities object.

  ## Reference
  https://dev.twitter.com/overview/api/entities
  """
  defstruct hashtags: nil, media: nil, symbols: nil, urls: nil,
    user_mentions: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Trend do
  defstruct events: nil, name: nil, promoted_content: nil, query: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.List do
  defstruct slug: nil, name: nil, created_at: nil, uri: nil, subscriber_count: nil,
    id_str: nil, member_count: nil, mode: nil, id: nil, full_name: nil,
    description: nil, user: nil, following: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Place do
  @moduledoc """
  Place object.

  ## Reference
  https://dev.twitter.com/overview/api/places
  """
  defstruct id: nil, url: nil, place_type: nil, name: nil, full_name: nil,
    country_code: nil, country: nil, contained_within: nil,
    bounding_box: nil, attributes: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Geo do
  defstruct type: nil, coordinates: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.DeletedTweet do
  defstruct status: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Limit do
  defstruct track: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.StallWarning do
  defstruct code: nil, message: nil, percent_full: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Cursor do
  defstruct items: nil, next_cursor: nil, previous_cursor: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.RequestToken do
  defstruct oauth_token: nil, oauth_token_secret: nil, oauth_callback_confirmed: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.AccessToken do
  defstruct oauth_token: nil, oauth_token_secret: nil, user_id: nil, screen_name: nil

  @type t :: %__MODULE__{}
end
