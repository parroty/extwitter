defmodule ExTwitter.Mixfile do
  use Mix.Project

  @source_url "https://github.com/parroty/extwitter"
  @version "0.14.0"

  def project do
    [
      app: :extwitter,
      version: @version,
      elixir: ">= 1.12.0",
      deps: deps(),
      docs: docs(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env:
        cli_env_for(:test, [
          "coveralls",
          "coveralls.detail",
          "coveralls.post",
          "vcr",
          "vcr.delete",
          "vcr.check",
          "vcr.show"
        ]),
    ]
  end

  defp cli_env_for(env, tasks) do
    Enum.reduce(tasks, [], fn key, acc -> Keyword.put(acc, :"#{key}", env) end)
  end

  def application do
    [
      mod: {ExTwitter, []},
      applications: [:inets, :ssl, :crypto, :logger, :oauther, :jason],
      extra_applications: extra_applications(Mix.env())
    ]
  end

  defp extra_applications(:test), do: common_extra_applications()
  defp extra_applications(:dev), do: common_extra_applications()
  defp extra_applications(_), do: []

  defp common_extra_applications do
    [:exvcr, :mock]
  end

  def deps do
    [
      {:oauther, "~> 1.3"},
      {:jason, "~> 1.1"},
      {:castore, "~> 1.0"},
      {:exvcr, "~> 0.14", only: :test},
      {:excoveralls, "~> 0.18", only: :test},
      {:meck, "~> 0.9", only: [:dev, :test]},
      {:mock, "~> 0.3", only: [:dev, :test]},
      {:ex_doc, ">= 0.0.0", only: [:dev, :docs], runtime: false},
      {:inch_ex, "~> 2.0", only: :docs},
      {:benchfella, "~> 0.3.3", only: :dev}
    ]
  end

  defp docs do
    [
      extras: [
        "CHANGELOG.md": [],
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      source_ref: "v#{@version}",
      formatters: ["html"]
    ]
  end

  defp package do
    [
      description: "Twitter client library for Elixir.",
      maintainers: ["parroty"],
      licenses: ["MIT"],
      links: %{
        "Changelog" => "https://hexdocs.pm/extwitter/changelog.html",
        "GitHub" => @source_url
      }
    ]
  end
end
