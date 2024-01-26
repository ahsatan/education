defmodule Servy.MixProject do
  use Mix.Project

  def project do
    [
      app: :servy,
      description: "Humble HTTP Server",
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :observer, :wx],
      mod: {Servy, []}, # automatically calls the given modules start w/ given args
      env: [port: 3000]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:poison, "~> 5.0"},
      {:earmark, "~> 1.4"},
      {:httpoison, "~> 2.2"}
    ]
  end
end