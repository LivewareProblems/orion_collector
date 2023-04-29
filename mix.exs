defmodule OrionCollector.MixProject do
  use Mix.Project

  @version "1.1.1"

  def project do
    [
      app: :orion_collector,
      version: @version,
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      name: "orion_collector",
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {OrionCollector.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dog_sketch, "~> 0.1.2"},
      {:ex2ms, "~> 1.6"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  def package() do
    [
      licenses: ["Apache-2.0"],
      description: "server side data collector for Orion profiler",
      links: %{github: "https://github.com/LivewareProblems/orion_collector"},
      source_url: "https://github.com/LivewareProblems/orion_collector"
    ]
  end

  defp docs do
    [
      source_ref: "v#{@version}",
      source_url: "https://github.com/LivewareProblems/orion_collector"
    ]
  end
end
