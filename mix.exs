defmodule ExTwitter.Mixfile do
  use Mix.Project

  def project do
    [ app: :extwitter,
      version: "0.1.4",
      elixir: "~> 0.14.2 or ~> 0.15.0",
      deps: deps,
      description: description,
      package: package,
      test_coverage: [tool: ExCoveralls] ]
  end

  # Configuration for the OTP application
  def application do
    [ mod: { ExTwitter, [] },
      applications: [:inets, :ssl, :crypto]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  def deps do
    [
      {:oauth, github: "tim/erlang-oauth"},
      {:jsex, "~> 2.0"},
      {:exvcr, "~> 0.3", only: [:dev, :test]},
      {:excoveralls, "~> 0.3", only: :dev},
      {:meck, "0.8.2", github: "eproxus/meck", tag: "0.8.2", only: :test},
      {:mock, github: "jjh42/mock", only: [:dev, :test]}
    ]
  end

  defp description do
    """
    Twitter client library for elixir.
    """
  end

  defp package do
    [ contributors: ["parroty"],
      licenses: ["MIT"],
      links: [ { "GitHub", "https://github.com/parroty/extwitter" } ] ]
  end
end
