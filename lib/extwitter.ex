defmodule ExTwitter do
  @moduledoc """
  Provides user interface for the Twitter API.
  """

  use Application.Behaviour

  defdelegate user_timeline,               to: ExTwitter.API.Timelines
  defdelegate user_timeline(options),      to: ExTwitter.API.Timelines
  defdelegate search(query, options),      to: ExTwitter.API.Search
  defdelegate search(query),               to: ExTwitter.API.Search
  defdelegate update(status),              to: ExTwitter.API.Tweets
  defdelegate update(status, options),     to: ExTwitter.API.Tweets
  defdelegate destroy_status(id),          to: ExTwitter.API.Tweets
  defdelegate destroy_status(id, options), to: ExTwitter.API.Tweets

  defdelegate configure(oauth),            to: ExTwitter.Config, as: :set

  def start(_type, _args) do
    ExTwitter.Config.start
    ExTwitter.Supervisor.start_link
  end
end
