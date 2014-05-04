defmodule ExTwitter.Mixfile do
  use Mix.Project

  def project do
    [ app: :extwitter,
      version: "0.0.2",
      elixir: ">= 0.12.4",
      deps: deps(Mix.env),
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
  def deps(:test) do
    deps(:dev)
  end

  def deps(:dev) do
    deps(:prod) ++
      [ {:exvcr, github: "parroty/exvcr"},
        {:excoveralls, github: "parroty/excoveralls"} ]
  end

  def deps(:prod) do
    [ {:oauth, github: "tim/erlang-oauth"},
      {:jsex, github: "talentdeficit/jsex"} ]
  end
end
