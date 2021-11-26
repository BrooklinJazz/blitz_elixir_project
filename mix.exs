defmodule BlitzElixirProject.MixProject do
  use Mix.Project

  def project do
    [
      app: :blitz_elixir_project,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {BlitzElixirProject, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:json, "~> 1.4"},
      {:httpoison, "~> 1.8"},
      {:mox, "~> 1.0", only: :test},
      {:faker, "~> 0.16", only: :test}
    ]
  end
end
