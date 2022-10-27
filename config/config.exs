import Config

config :extwitter, :oauth, [
   consumer_key:        System.get_env("TWITTER_CONSUMER_KEY"),
   consumer_secret:     System.get_env("TWITTER_CONSUMER_SECRET"),
   access_token:        System.get_env("TWITTER_ACCESS_TOKEN"),
   access_token_secret: System.get_env("TWITTER_ACCESS_SECRET")
]

config :extwitter, :proxy, [
   server:   System.get_env("EXTWITTER_PROXY_SERVER"),
   port:     System.get_env("EXTWITTER_PROXY_PORT"),
   user:     System.get_env("EXTWITTER_PROXY_USER"),
   password: System.get_env("EXTWITTER_PROXY_PASSWORD")
]
