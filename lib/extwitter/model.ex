defmodule ExTwitter.Model.Tweet do
  @moduledoc """
  Tweet object.

  ## Reference
  [Tweet object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/tweet-object)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct coordinates: nil, created_at: nil, current_user_retweet: nil,
    entities: nil, extended_entities: nil, favorite_count: nil, favorited: nil,
    filter_level: nil, id_str: nil, id: nil, in_reply_to_screen_name: nil,
    in_reply_to_status_id_str: nil, in_reply_to_status_id: nil, in_reply_to_user_id_str: nil,
    in_reply_to_user_id: nil, is_quote_status: nil, lang: nil, matching_rules: nil,
    place: nil, possibly_sensitive: nil, quote_count: nil, quoted_status_id_str: nil,
    quoted_status_id: nil, quoted_status: nil, raw_data: nil, reply_count: nil,
    retweet_count: nil, retweeted_status: nil, retweeted: nil, scopes: nil, source: nil,
    text: nil, full_text: nil, truncated: nil, user: nil, withheld_copyright: nil,
    withheld_in_countries: nil, withheld_scope: nil

  @type t :: %__MODULE__{
    coordinates: ExTwitter.Model.Coordinates.t() | nil,
    created_at: String.t(),
    current_user_retweet: %{id: pos_integer, id_str: String.t()} | nil,
    entities: ExTwitter.Model.Entities.t(),
    extended_entities: ExTwitter.Model.ExtendedEntities.t() | nil,
    favorite_count: non_neg_integer | nil,
    favorited: boolean | nil,
    filter_level: String.t(),
    id_str: String.t(),
    id: pos_integer,
    in_reply_to_screen_name: String.t() | nil,
    in_reply_to_status_id_str: String.t() | nil,
    in_reply_to_status_id: pos_integer | nil,
    in_reply_to_user_id_str: String.t() | nil,
    in_reply_to_user_id: pos_integer | nil,
    is_quote_status: boolean,
    lang: String.t() | nil,
    matching_rules: [ExTwitter.Model.Rule.t()],
    place: ExTwitter.Model.Place.t() | nil,
    possibly_sensitive: boolean | nil,
    quote_count: non_neg_integer | nil,
    quoted_status_id_str: String.t() | nil,
    quoted_status_id: pos_integer | nil,
    quoted_status: ExTwitter.Model.Tweet.t() | nil,
    raw_data: map,
    reply_count: non_neg_integer | nil,
    retweet_count: non_neg_integer,
    retweeted_status: ExTwitter.Model.Tweet.t() | nil,
    retweeted: boolean,
    scopes: map | nil,
    source: String.t(),
    text: String.t(),
    full_text: String.t(),
    truncated: boolean,
    user: ExTwitter.Model.User.t(),
    withheld_copyright: boolean | nil,
    withheld_in_countries: [String.t()] | nil,
    withheld_scope: String.t() | nil
  }
end

defmodule ExTwitter.Model.Upload do
  @derive {Inspect, except: [:raw_data]}
  defstruct expires_after_secs: nil, media_id: nil, media_id_string: nil, size: nil,
    raw_data: nil

  @type t :: %__MODULE__{
    expires_after_secs: non_neg_integer,
    media_id: pos_integer,
    media_id_string: String.t(),
    size: pos_integer | nil,
    raw_data: map
  }
end

defmodule ExTwitter.Model.User do
  @moduledoc """
  User object.

  ## Reference
  [User object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/user-object)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct created_at: nil, default_profile_image: nil, default_profile: nil,
    derived: nil, description: nil, favourites_count: nil, followers_count: nil,
    friends_count: nil, id_str: nil, id: nil, listed_count: nil, location: nil,
    name: nil, profile_banner_url: nil, profile_image_url_https: nil, protected: nil,
    raw_data: nil, screen_name: nil, statuses_count: nil, url: nil, verified: nil,
    withheld_in_countries: nil, withheld_scope: nil

  @type t :: %__MODULE__{
    created_at: String.t(),
    default_profile_image: boolean,
    default_profile: boolean,
    derived: [ExTwitter.Model.ProfileGeo.t()] | nil,
    description: String.t() | nil,
    favourites_count: non_neg_integer,
    followers_count: non_neg_integer,
    friends_count: non_neg_integer,
    id_str: String.t(),
    id: pos_integer,
    listed_count: non_neg_integer,
    location: String.t() | nil,
    name: String.t(),
    profile_banner_url: String.t(),
    profile_image_url_https: String.t(),
    protected: boolean,
    raw_data: map,
    screen_name: String.t(),
    statuses_count: non_neg_integer,
    url: String.t() | nil,
    verified: boolean,
    withheld_in_countries: [String.t()],
    withheld_scope: String.t()
  }
end

defmodule ExTwitter.Model.ProfileBanner do
  @moduledoc """
  Profile Banner object.

  ## Reference
  [GET users/profile_banner](https://developer.twitter.com/en/docs/accounts-and-users/manage-account-settings/api-reference/get-users-profile_banner)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct sizes: nil, raw_data: nil

  @type t :: %__MODULE__{sizes: %{required(String.t()) => map}, raw_data: map}
end

defmodule ExTwitter.Model.DirectMessage do
  @derive {Inspect, except: [:raw_data]}
  defstruct created_at: nil, entities: nil, id: nil, id_str: nil,
    recipient: nil, recipient_id: nil, recipient_screen_name: nil,
    sender: nil, sender_id: nil, sender_screen_name: nil, text: nil

  @type t :: %__MODULE__{}
end

defmodule ExTwitter.Model.Entities do
  @moduledoc """
  Entities object.

  ## Reference
  [Entities object[(https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct hashtags: nil, media: nil, symbols: nil, urls: nil, user_mentions: nil,
    polls: nil, raw_data: nil

  @type t :: %__MODULE__{
    hashtags: [ExTwitter.Model.Hashtag],
    media: [ExTwitter.Model.Media],
    symbols: [ExTwitter.Model.Symbol],
    urls: [ExTwitter.Model.URL],
    user_mentions: [ExTwitter.Model.UserMention],
    polls: [ExTwitter.Model.Poll],
    raw_data: map
  }
end

defmodule ExTwitter.Model.ExtendedEntities do
  @moduledoc """
  Extended Entities object.

  ## Reference
  [Extended Entities object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/extended-entities-object)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct hashtags: nil, media: nil, symbols: nil, urls: nil, user_mentions: nil,
    polls: nil, raw_data: nil

  @type t :: %__MODULE__{
    hashtags: [ExTwitter.Model.Hashtag],
    media: [ExTwitter.Model.Media],
    symbols: [ExTwitter.Model.Symbol],
    urls: [ExTwitter.Model.URL],
    user_mentions: [ExTwitter.Model.UserMention],
    polls: [ExTwitter.Model.Poll],
    raw_data: map
  }
end

defmodule ExTwitter.Model.Hashtag do
  @moduledoc """
  Hashtag object.

  ## Reference
  [Hashtag object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#hashtags)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct indices: nil, text: nil, raw_data: nil

  @type t :: %__MODULE__{
    indices: [non_neg_integer],
    text: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.Media do
  @moduledoc """

  ## Reference
  [Media object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#media)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct display_url: nil, expanded_url: nil, id: nil, id_str: nil, indices: nil,
    media_url: nil, media_url_https: nil, sizes: nil, source_status_id: nil,
    source_status_id_str: nil, type: nil, url: nil, raw_data: nil

  @type t :: %__MODULE__{
    display_url: String.t(),
    expanded_url: String.t(),
    id: pos_integer,
    id_str: String.t(),
    indices: [non_neg_integer],
    media_url: String.t(),
    media_url_https: String.t(),
    sizes: %{required(String.t()) => ExTwitter.Model.Size.t()},
    source_status_id: pos_integer | nil,
    source_status_id_str: String.t() | nil,
    type: String.t(),
    url: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.Size do
  @moduledoc """
  Size object.

  ## Reference
  [Size object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#size)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct h: nil, w: nil, resize: nil, raw_data: nil

  @type t :: %__MODULE__{
    h: pos_integer,
    w: pos_integer,
    resize: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.Symbol do
  @moduledoc """
  Symbol object.

  ## Reference
  [Symbol object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#symbols)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct indices: nil, text: nil, raw_data: nil

  @type t :: %__MODULE__{
    indices: [non_neg_integer],
    text: String.t(),
    raw_data: map
  }
end


defmodule ExTwitter.Model.URL do
  @moduledoc """
  URL object.

  ## Reference
  [URL object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#urls)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct display_url: nil, expanded_url: nil, indices: nil, url: nil, unwound: nil, raw_data: nil

  @type t :: %__MODULE__{
    display_url: String.t(),
    expanded_url: String.t(),
    indices: [non_neg_integer],
    url: String.t(),
    unwound: map | nil,
    raw_data: map
  }
end

defmodule ExTwitter.Model.UserMention do
  @moduledoc """
  User mention object.

  ## Reference
  [User mention object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#mentions)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct id: nil, id_str: nil, indices: nil, name: nil, screen_name: nil, raw_data: nil

  @type t :: %__MODULE__{
    id: pos_integer,
    id_str: String.t(),
    indices: [non_neg_integer],
    name: String.t(),
    screen_name: String.t()
  }
end


defmodule ExTwitter.Model.Poll do
  @moduledoc """
  Poll object.

  ## Reference
  [Poll object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/entities-object#polls)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct options: nil, end_datetime: nil, duration_minutes: nil, raw_data: nil

  @type t :: %__MODULE__{
    options: [map],
    end_datetime: String.t(),
    duration_minutes: pos_integer,
    raw_data: map
  }
end

defmodule ExTwitter.Model.Rule do
  @moduledoc """
  Matching rules object.

  ## Reference
  [Matching rules](https://developer.twitter.com/en/docs/tweets/enrichments/overview/matching-rules)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct tag: nil, id: nil, id_str: nil, raw_data: nil

  @type t :: %__MODULE__{tag: String.t(), id: pos_integer, id_str: String.t(), raw_data: map}
end

defmodule ExTwitter.Model.ProfileGeo do
  @moduledoc """
  Profile Geo object.

  ## Reference
  [Profile Geo](https://developer.twitter.com/en/docs/tweets/enrichments/overview/profile-geo)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct country: nil, country_code: nil, locality: nil, region: nil, sub_region: nil,
    full_name: nil, geo: nil, raw_data: nil

  @type t :: %__MODULE__{
    country: String.t(),
    country_code: String.t(),
    locality: String.t(),
    region: String.t(),
    sub_region: String.t(),
    full_name: String.t(),
    geo: ExTwitter.Model.Geo.t()
  }
end

defmodule ExTwitter.Model.Trend do
  @moduledoc """
  Trend object.

  ## Reference
  https://developer.twitter.com/en/docs/trends/trends-for-location/api-reference/get-trends-place
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct name: nil, promoted_content: nil, query: nil, raw_data: nil, tweet_volume: nil, url: nil

  @type t :: %__MODULE__{
    name: String.t(),
    promoted_content: String.t() | nil,
    query: String.t(),
    raw_data: map,
    tweet_volume: pos_integer | nil,
    url: String.t()
  }
end

defmodule ExTwitter.Model.List do
  @moduledoc """
  List object.

  ## Reference
  https://developer.twitter.com/en/docs/accounts-and-users/create-manage-lists/api-reference/get-lists-show
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct created_at: nil, description: nil, following: nil, full_name: nil,
    id_str: nil, id: nil, member_count: nil, mode: nil, name: nil, raw_data: nil,
    slug: nil, subscriber_count: nil, uri: nil, user: nil

  @type t :: %__MODULE__{
    created_at: String.t(),
    description: String.t(),
    following: boolean,
    full_name: String.t(),
    id_str: String.t(),
    id: pos_integer,
    member_count: non_neg_integer,
    mode: String.t(),
    name: String.t(),
    raw_data: map,
    slug: String.t(),
    subscriber_count: non_neg_integer,
    uri: String.t(),
    user: ExTwitter.Model.User.t()
  }
end

defmodule ExTwitter.Model.Place do
  @moduledoc """
  Place object.

  ## Reference
  [Place object](https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/geo-objects#place)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct id: nil, url: nil, place_type: nil, name: nil, full_name: nil,
    country_code: nil, country: nil, contained_within: nil,
    bounding_box: nil, attributes: nil, raw_data: nil

  @type t :: %__MODULE__{
    id: String.t(),
    url: String.t(),
    place_type: String.t(),
    name: String.t(),
    full_name: String.t(),
    country_code: String.t(),
    country: String.t(),
    contained_within: [ExTwitter.Model.Place.t()],
    bounding_box: ExTwitter.Model.BoundingBox.t(),
    attributes: nil,
    raw_data: map
  }
end

defmodule ExTwitter.Model.BoundingBox do
  @moduledoc """
  Bounding box object.

  ## Reference
  https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/geo-objects
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct coordinates: nil, type: nil, raw_data: nil

  @type t :: %__MODULE__{
    coordinates: [[[float]]],
    type: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.Coordinates do
  @moduledoc """
  Coordinates object.

  ## Reference
  https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/geo-objects#coordinates
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct coordinates: nil, type: nil, raw_data: nil

  @type t :: %__MODULE__{
    coordinates: [float],
    type: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.Geo do
  @moduledoc """
  Geo object.

  ## Reference
  https://developer.twitter.com/en/docs/tweets/data-dictionary/overview/geo-objects
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct coordinates: nil, type: nil, raw_data: nil

  @type t :: %__MODULE__{
    coordinates: [float],
    type: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.DeletedTweet do
  @moduledoc """
  Deleted Tweet object.

  ## Reference
  [Status deletion notices](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/statuses-filter)
  """
  defstruct status: nil

  @type t :: %__MODULE__{status: map}
end

defmodule ExTwitter.Model.Limit do
  @moduledoc """
  Limit object.

  ## Reference
  [Limit notices](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/statuses-filter)
  """
  defstruct track: nil

  @type t :: %__MODULE__{track: non_neg_integer}
end

defmodule ExTwitter.Model.StallWarning do
  @moduledoc """
  Stall Warning object.

  ## Reference
  [Stall warnings](https://developer.twitter.com/en/docs/tweets/filter-realtime/overview/statuses-filter)
  """
  defstruct code: nil, message: nil, percent_full: nil

  @type t :: %__MODULE__{
    code: String.t(),
    message: String.t(),
    percent_full: non_neg_integer
  }
end

defmodule ExTwitter.Model.Cursor do
  @moduledoc """
  Cursor object.

  ## Reference
  [Cursoring](https://developer.twitter.com/en/docs/basics/cursoring)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct items: nil, next_cursor: nil, previous_cursor: nil, raw_data: nil

  @type t :: %__MODULE__{
    items: [ExTwitter.Model.User.t()] | [pos_integer],
    next_cursor: integer,
    previous_cursor: integer,
    raw_data: map
  }
end

defmodule ExTwitter.Model.RequestToken do
  @moduledoc """
  Request Token object.

  ## Reference
  [POST oauth/request_token](https://developer.twitter.com/en/docs/basics/authentication/api-reference/request_token)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct oauth_token: nil, oauth_token_secret: nil, oauth_callback_confirmed: nil,
    raw_data: nil

  @type t :: %__MODULE__{
    oauth_token: String.t(),
    oauth_token_secret: String.t(),
    oauth_callback_confirmed: boolean,
    raw_data: map
  }
end

defmodule ExTwitter.Model.AccessToken do
  @moduledoc """
  Access Token object.

  ## Reference
  [POST oauth/access_token](https://developer.twitter.com/en/docs/basics/authentication/api-reference/access_token)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct oauth_token: nil, oauth_token_secret: nil, user_id: nil, screen_name: nil,
    raw_data: nil

  @type t :: %__MODULE__{
    oauth_token: String.t(),
    oauth_token_secret: String.t(),
    user_id: String.t(),
    screen_name: String.t(),
    raw_data: map
  }
end

defmodule ExTwitter.Model.SearchResponse do
  @moduledoc """
  Search Response object.

  ## Reference
  https://developer.twitter.com/en/docs/tweets/search/api-reference/get-search-tweets
  """
  defstruct statuses: nil, metadata: nil

  @type t :: %__MODULE__{statuses: [ExTwitter.Model.Tweet.t()], metadata: map}
end

defmodule ExTwitter.Model.Relationship do
  @moduledoc """
  Relationship object.

  ## Reference
  [GET friendships/lookup](https://developer.twitter.com/en/docs/accounts-and-users/follow-search-get-users/api-reference/get-friendships-lookup)
  """
  @derive {Inspect, except: [:raw_data]}
  defstruct name: nil, screen_name: nil, id: nil, id_str: nil, connections: nil,
    raw_data: nil

  @type t :: %__MODULE__{
    name: String.t(),
    screen_name: String.t(),
    id: pos_integer,
    id_str: String.t(),
    connections: [String.t()],
    raw_data: map
  }
end
