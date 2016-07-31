0.7.2
------
#### Changes
* Update dependencies.

0.7.1
------
#### Enhancements
* Improve handling for connection error.
    - Trap connection errors and raise with custom exception (#45).
* Support user streaming function.
    - ExTwitter.stream_user

0.7.0
------
#### Changes
* Drop Timex.Date.now() call in favor of native Erlang (#43).

0.6.3
------
#### Enhancements
* Implement creating/destroying favorites (#41).
    - ExTwitter.create_favorite
    - ExTwitter.destroy_favorite

#### Changes
* Expose user_id and screen_name from access_token response (#40).

0.6.2
------
#### Enhancements
* Add configurations for proxy (#36).

#### Changes
* Add extended_entities field to Model.Tweet (#37).

0.6.1
------
#### Changes
* Fix stream operations (ex. Stream.take) in different processes fail to receive tweets (#12, #19).

0.6.0
------
#### Changes
* Fix auth methods so that redirect_url makes sense (#34).
    - Replaces ExTwitter.request_token/0 with ExTwitter.request_token/1 which has redirect_url parameter.
    - Removes redirect_url parameter from ExTwitter.authorize_url.
    - Removes redirect_url parameter from ExTwitter.authenticate_url.
* Update versions of dependent modules.

0.5.5
------
#### Enhancements
* Improve stability of streaming connection.
    - Restart stream when connection closed remotely or no messages sent (#32).

0.5.4
------
#### Enhancements
* Add remaining direct messages API end points (#30).
    - ExTwitter.sent_direct_messages
    - ExTwitter.destroy_direct_message
    - ExTwitter.new_direct_message

0.5.3
------
#### Enhancements
* Support showing direct messages (#29).
    - ExTwitter.direct_messages
    - ExTwitter.direct_message

0.5.2
------
#### Changes
* Add missing attributes for Tweet, User, Entities models (#28).

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
