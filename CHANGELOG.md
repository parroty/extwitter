0.4.0
------
#### Enhancements

#### Changes
* Maps returned by the APIs will have atom keys instead of string keys.

0.3.0
------
#### Enhancements
* Add `ExTwitter.follower_ids`, `ExTwitter.friend_ids`.
* Add `ExTwitter.RateLimitExceededError` for handling rate limit exceeded case.

#### Changes
* `ExTwitter.followers` and `ExTwitter.friends` now return `ExTwitter.Model.Cursor` instead of `ExTwitter.Model.User`. Call `cursor.items` for the returned cursor to fetch the list of users or ids.
