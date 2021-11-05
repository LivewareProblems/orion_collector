defmodule OrionCollector.MixProject do
  use Mix.Project

  def project do
    [
      app: :orion_collector,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OrionCollector.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dog_sketch, "~> 0.1.2"},
      {:ex2ms, "~> 1.6"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  def package() do
    [
      licenses: "Apache-2.0",
      description: "server side data collector for Orion profiler",
      links: %{"GitHub" => "https://github.com/DianaOlympos/orion_collector"},
      source_url: "https://github.com/DianaOlympos/orion_collector"
    ]
  end
end
