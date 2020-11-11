defmodule ExTwitter.Mixfile do
  use Mix.Project

  def project do
    [ app: :extwitter,
      version: "0.12.2",
      elixir: ">= 1.4.0",
      deps: deps(),
      description: description(),
      package: package(),
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
      applications: [:inets, :ssl, :crypto, :logger]]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  def deps do
    [
      {:oauther, "~> 1.1"},
      {:jason, "~> 1.1"},
      {:exvcr, "~> 0.8", only: :test},
      {:excoveralls, "~> 0.7", only: :test},
      {:meck, "~> 0.8.13", only: [:dev, :test]},
      {:mock, "~> 0.2", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :docs]},
      {:inch_ex, "~> 2.0", only: :docs},
      {:benchfella, "~> 0.3.3", only: :dev}
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
