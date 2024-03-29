defmodule OrionCollector.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: OrionCollector.Aggregator.Registry},
      OrionCollector.Tracer,
      {DynamicSupervisor, strategy: :one_for_one, name: OrionCollector.AggregatorSupervisor}

      # Starts a worker by calling: OrionCollector.Worker.start_link(arg)
      # {OrionCollector.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :rest_for_one, name: OrionCollector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
