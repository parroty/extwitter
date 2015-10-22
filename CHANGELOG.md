0.5.1
------
#### Changes
* Fix application naming (:ex_twitter -> :extwitter) in config.exs (#25, #26).
    - Plase use the name :extwitter instead of :ex_twitter after this version.

0.5.0
------
#### Changes
* Updates for elixir v1.1 (#24).

0.4.5
------
#### Enhancements
* Support verifying credentials (#23).
    - ExTwitter.verify_credentials

0.4.4
------
#### Enhancements
* Support authentication / authorization (#21).
    - ExTwitter.request_token
    - ExTwitter.authorize_url
    - ExTwitter.authenticate_url
    - ExTwitter.access_token

0.4.3
------
#### Enhancements
* Support following and unfollowing.
    - ExTwitter.follow
    - ExTwitter.unfollow
* Support retweeting.
    - ExTwitter.retweet

0.4.2
------
#### Enhancements
* Support posting tweets with image (#20).
    - ExTwitter.update_with_media

0.4.1
------
#### Enhancements
* Support specifying `user_id` as basic parameter in addition to the existing `screen_name` in the following functions.
    - ExTwitter.follower_ids
    - ExTwitter.followers
    - ExTwitter.friend_ids
    - ExTwitter.friends
    - ExTwitter.lists
    - ExTwitter.user_lookup

0.4.0
------
#### Changes
* Maps returned by the APIs will have atom keys instead of string keys.
* Use [poison](https://hex.pm/packages/poison) as internal JSON parser.
* Apply some benchmark related updates (#11, #13).

0.3.0
------
#### Enhancements
* Add `ExTwitter.follower_ids`, `ExTwitter.friend_ids`.
* Add `ExTwitter.RateLimitExceededError` for handling rate limit exceeded case.

#### Changes
* `ExTwitter.followers` and `ExTwitter.friends` now return `ExTwitter.Model.Cursor` instead of `ExTwitter.Model.User`. Call `cursor.items` for the returned cursor to fetch the list of users or ids.
