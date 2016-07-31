defmodule ExTwitter.Mixfile do
  use Mix.Project

  def project do
    [ app: :extwitter,
      version: "0.7.2",
      elixir: ">= 1.0.0",
      deps: deps,
      description: description,
      package: package,
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: cli_env_for(:test, [
        "coveralls", "coveralls.detail", "coveralls.post",
        "vcr", "vcr.delete", "vcr.check", "vcr.show"
      ]),
      docs: [main: ExTwitter] ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn(key, acc) -> Keyword.put(acc, :"#{key}", env) end)
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
      {:poison, "~> 2.0"},
      {:exvcr, "~> 0.8", only: :test},
      {:excoveralls, "~> 0.5", only: :test},
      {:meck, "~> 0.8.2", only: [:dev, :test]},
      {:mock, github: "parroty/mock", only: [:dev, :test], branch: "fix"},
      {:ex_doc, "~> 0.11", only: :docs},
      {:earmark, "~> 0.1", only: :docs},
      {:inch_ex, "~> 0.5.1", only: :docs},
      {:benchfella, github: "alco/benchfella", only: :dev}
    ]
  end

  defp description do
    """
    Twitter client library for elixir.
    """
  end

  defp package do
    [ maintainers: ["parroty"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parroty/extwitter"} ]
  end
end
