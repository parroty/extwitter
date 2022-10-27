# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v0.14.0 - 2022-10-28

#### Changes
- Resolve compile warnings -> Adjust Config to not warn (#156).
  - Bump minimum elixir version to 1.9

## v0.13.1 - 2022-09-08

#### Changes
- Fix error on elixir v1.14.
  - Fix derive missing field issue (#150).

## v0.13.0 - 2021-12-28

#### Changes
- Update oauther for OTP 24 environment (#149).
- Refine documents (#139).

## v0.12.5 - 2021-11-11

#### Changes
- Allow for multiple tweets in a given message (#104).

## v0.12.4 - 2021-08-11

#### Enhancements
- Support destroy lists API (#145).
- Support add members to a list API (#146).

## v0.12.3 - 2021-08-07

#### Enhancements
- Support create lists API (#144).

## v0.12.2 - 2020-11-11

#### Changes
- Revert "Covering all patterns and preventing errors" (#136).
   - Fix for breaking change.

## v0.12.1 - 2020-11-10

#### Changes
- Fix behavior definition for access_token and request_token (#123).
- Fix for auth.ex to cover all patterns and preventing errors (#124).

## v0.12.0 - 2020-02-09

#### Changes
Replaced poison dep with jason 1.1 (#121).

#### Enhancements
- Add `full_text` field back into tweet model (#122).

## v0.11.0 - 2020-01-08

#### Changes
- Update dependency to fix error with elixir v1.8 (#112, #113).

## v0.10.0 - 2019-12-30

#### Enhancements
- Add raw_data fields and specs to models (#117).

## v0.9.6 - 2019-09-08

#### Enhancements
- Add support for update with chunked media upload (#114).

## v0.9.5 - 2019-08-04

#### Changes
- Move all specs into a behaviour file (#108).

## v0.9.4 - 2019-07-04

#### Enhancements
- Implement friendships lookup (#111).

## v0.9.3 - 2018-05-20

#### Changes
- Fix ArgumentError or UnicodeConversionError when parsing request params with a list as value (#102).

## v0.9.2 - 2018-04-15

#### Changes
* Fixed crash if message is not string (#98).

## v0.9.1 - 2017-12-10

#### Changes
* Add extended_tweet field to tweet struct (#95).

## v0.9.0 - 2017-10-09

#### Enhancements
* Fix - no metadata for search results (#84).
* Immediately stop stream when oauth config is invalid (#81, #87).
* Add unretweet function (#90).

#### Changes
* Requires elixir 1.4.0 or later.
   - Bugfix/cleanup char list deprecation warnings (#94).
   - Cleanup deps (#89).

## v0.8.6 - 2017-07-20

#### Enhancements
* Add media chunk upload functionality (#83).

## v0.8.5 - 2017-06-25

#### Changes
* Update dependency.
  - Bumped poison dep to 3.0 (#80).

## v0.8.4 - 2017-06-18

#### Changes
* Fix for crash when calling user_lookup on more than 2 twitter IDs (#78).

## v0.8.3 - 2017-03-13

#### Enhancements
* Add support for blocking/unblocking users (#71).

## v0.8.2 - 2017-02-07

#### Enhancements
* Add support for users/profile_banner (#70).

#### Changes
* Update dependencies.

## v0.8.1 - 2017-01-31

#### Changes
* Fix option for account/verify_credentials (#68).

## v0.8.0 - 2017-01-22

#### Changes
* OAuth dependency library is updated (#63).
    - Adding `{:oauth, github: "tim/erlang-oauth"}` in mix.exs becomes not required.

* Configurations for proxy is simplified.
    - https://github.com/parroty/extwitter#proxy

* Fix [mix bench] task error and library updates.
    - Update benchfella and remove some warning notes about setup/teardown.

## v0.7.3 - 2016-12-29

#### Enhancements
* Allow for looking up multiple users with a list (#61).
* Add new Tweet fields for extended tweets (#57).
* Support for direct messages in streaming API (#60).

## v0.7.2 - 2016-07-31

#### Changes
* Update dependencies.

## v0.7.1 - 2016-04-23

#### Enhancements
* Improve handling for connection error.
    - Trap connection errors and raise with custom exception (#45).
* Support user streaming function.
    - ExTwitter.stream_user

## v0.7.0 - 2016-03-19

#### Changes
* Drop Timex.Date.now() call in favor of native Erlang (#43).

## v0.6.3 - 2016-03-05

#### Enhancements
* Implement creating/destroying favorites (#41).
    - ExTwitter.create_favorite
    - ExTwitter.destroy_favorite

#### Changes
* Expose user_id and screen_name from access_token response (#40).

## v0.6.2 - 2016-01-31

#### Enhancements
* Add configurations for proxy (#36).

#### Changes
* Add extended_entities field to Model.Tweet (#37).

## v0.6.1 - 2016-01-11

#### Changes
* Fix stream operations (ex. Stream.take) in different processes fail to receive tweets (#12, #19).

## v0.6.0 - 2015-12-20

#### Changes
* Fix auth methods so that redirect_url makes sense (#34).
    - Replaces ExTwitter.request_token/0 with ExTwitter.request_token/1 which has redirect_url parameter.
    - Removes redirect_url parameter from ExTwitter.authorize_url.
    - Removes redirect_url parameter from ExTwitter.authenticate_url.
* Update versions of dependent modules.

## v0.5.5 - 2015-12-13

#### Enhancements
* Improve stability of streaming connection.
    - Restart stream when connection closed remotely or no messages sent (#32).

## v0.5.4 - 2015-11-08

#### Enhancements
* Add remaining direct messages API end points (#30).
    - ExTwitter.sent_direct_messages
    - ExTwitter.destroy_direct_message
    - ExTwitter.new_direct_message

## v0.5.3 - 2015-11-05

#### Enhancements
* Support showing direct messages (#29).
    - ExTwitter.direct_messages
    - ExTwitter.direct_message

## v0.5.2 - 2015-10-29

#### Changes
* Add missing attributes for Tweet, User, Entities models (#28).

## v0.5.1 - 2015-10-22

#### Changes
* Fix application naming (:ex_twitter -> :extwitter) in config.exs (#25, #26).
    - Please use the name :extwitter instead of :ex_twitter after this version.

## v0.5.0 - 2015-10-04

#### Changes
* Updates for elixir v1.1 (#24).

## v0.4.4 - 2015-08-31

#### Enhancements
* Support verifying credentials (#23).
    - ExTwitter.verify_credentials

## v0.4.3 - 2015-08-16

#### Enhancements
* Support authentication / authorization (#21).
    - ExTwitter.request_token
    - ExTwitter.authorize_url
    - ExTwitter.authenticate_url
    - ExTwitter.access_token

## v0.4.2 - 2015-08-15

#### Enhancements
* Support following and unfollowing.
    - ExTwitter.follow
    - ExTwitter.unfollow
* Support retweeting.
    - ExTwitter.retweet

## v0.4.1 - 2015-07-12

#### Enhancements
* Support posting tweets with image (#20).
    - ExTwitter.update_with_media

## v0.4.0 - 2015-03-07

#### Enhancements
* Support specifying `user_id` as basic parameter in addition to the existing `screen_name` in the following functions.
    - ExTwitter.follower_ids
    - ExTwitter.followers
    - ExTwitter.friend_ids
    - ExTwitter.friends
    - ExTwitter.lists
    - ExTwitter.user_lookup

## v0.4.0 - 2015-03-07

#### Changes
* Maps returned by the APIs will have atom keys instead of string keys.
* Use [poison](https://hex.pm/packages/poison) as internal JSON parser.
* Apply some benchmark related updates (#11, #13).

## v0.3.0 - 2015-01-23

#### Enhancements
* Add `ExTwitter.follower_ids`, `ExTwitter.friend_ids`.
* Add `ExTwitter.RateLimitExceededError` for handling rate limit exceeded case.

#### Changes
* `ExTwitter.followers` and `ExTwitter.friends` now return `ExTwitter.Model.Cursor` instead of `ExTwitter.Model.User`. Call `cursor.items` for the returned cursor to fetch the list of users or ids.
