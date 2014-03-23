defrecord ExTwitter.Model.Tweet,
  contributors: nil, coordinates: nil, created_at: nil, entities: nil,
  favorite_count: nil, favorited: nil, geo: nil, id: nil, id_str: nil,
  in_reply_to_screen_name: nil, in_reply_to_status_id: nil,
  in_reply_to_status_id_str: nil, in_reply_to_user_id: nil,
  in_reply_to_user_id_str: nil, lang: nil, place: nil,
  retweet_count: nil, retweeted: nil, source: nil, text: nil,
  truncated: nil, user: nil

defrecord ExTwitter.Model.User,
  contributors_enabled: nil, created_at: nil, default_profile: nil,
  default_profile_image: nil, description: nil, entities: nil,
  favourites_count: nil, follow_request_sent: nil, followers_count: nil,
  following: nil, friends_count: nil, geo_enabled: nil, id: nil,
  id_str: nil, is_translation_enabled: nil, is_translator: nil,
  lang: nil, listed_count: nil, location: nil, name: nil,
  notifications: nil, profile_background_color: nil,
  profile_background_image_url: nil,
  profile_background_image_url_https: nil, profile_background_tile: nil,
  profile_image_url: nil, profile_image_url_https: nil,
  profile_link_color: nil, profile_sidebar_border_color: nil,
  profile_sidebar_fill_color: nil, profile_text_color: nil,
  profile_use_background_image: nil, protected: nil, screen_name: nil,
  statuses_count: nil, time_zone: nil, url: nil, utc_offset: nil,
  verified: nil

defrecord ExTwitter.Model.Entities,
  hashtags: nil, symbols: nil, urls: nil, user_mentions: nil

defrecord ExTwitter.Model.Trend,
  events: nil, name: nil, promoted_content: nil, query: nil

defrecord ExTwitter.Model.List,
  slug: nil, name: nil, created_at: nil, uri: nil, subscriber_count: nil,
  id_str: nil, member_count: nil, mode: nil, id: nil, full_name: nil,
  description: nil, user: nil, following: nil
