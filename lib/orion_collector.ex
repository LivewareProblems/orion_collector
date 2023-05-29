defmodule OrionCollector do
  @moduledoc """
  OrionCollector is a child of Orion.

  It only exist in order to separate collecting the traces in each nodes from
  Orion.

  All these API are considered private.
  """

  def start_all_node_tracers(mfa, self, start_status \\ :running) do
    if self do
      OrionCollector.Tracer.start_tracer(mfa, self(), start_status)
    end

    :erpc.multicall(
      list_nodes(),
      OrionCollector.Tracer,
      :start_tracer,
      [mfa, self(), start_status],
      5_000
    )

    :ok
  end

  def pause_all_node_tracers(self) do
    if self do
      OrionCollector.Tracer.change_status(:paused)
    end

    :erpc.multicall(list_nodes(), OrionCollector.Tracer, :change_status, [:paused], 5_000)
  end

  @spec restart_all_node_tracers(any) :: [
          {:error, {:erpc, any} | {:exception, any, list}}
          | {:exit, {:exception, any} | {:signal, any}}
          | {:ok, any}
          | {:throw, any}
        ]
  def restart_all_node_tracers(self) do
    if self do
      OrionCollector.Tracer.change_status(:running)
    end

    :erpc.multicall(list_nodes(), OrionCollector.Tracer, :change_status, [:runnning], 5_000)
  end

  def capture_all_nodes_slowest_calls(mfa, self, timing_ms) do
    if self do
      OrionCollector.Aggregator.intercept_slowest_calls(mfa, timing_ms)
    end

    :erpc.multicall(
      list_nodes(),
      OrionCollector.Aggregator,
      :intercept_slowest_calls,
      [mfa, timing_ms],
      5_000
    )
  end

  def stop_all_nodes_slowest_calls(mfa, self) do
    if self do
      OrionCollector.Aggregator.stop_slowest_calls(mfa)
    end

    :erpc.multicall(
      list_nodes(),
      OrionCollector.Aggregator,
      :stop_slowest_calls,
      [mfa],
      5_000
    )
  end

  defp list_nodes() do
    Node.list(:connected)
  end
end
