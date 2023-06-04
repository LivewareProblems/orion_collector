defmodule OrionCollector.Tracer do
  use GenServer

  alias OrionCollector.Aggregator

  @moduledoc """
  This is the process that collect the Trace, then dispatch them per aggregator

  There is one Tracer per node, but one Aggregator per MFA being traced.
  """

  def start_tracer(mfa, pid, start_status) do
    Aggregator.start_agg(mfa, pid)
    change_status(start_status)
  end

  @spec change_status(any) :: any
  def change_status(status) do
    GenServer.call(__MODULE__, status)
  end

  def stop(pid) do
    GenServer.stop(pid, :normal, 5_000)
  end

  def start_link(init \\ []) do
    GenServer.start_link(__MODULE__, init, name: __MODULE__)
  end

  def child_spec(args) do
    %{
      id: OrionCollector.Tracer,
      start: {OrionCollector.Tracer, :start_link, [args]},
      restart: :permanent
    }
  end

  # --PRIVATE--
  @impl true
  def init(_start) do
    running_trace(false)

    initial_state = %{running_status: :paused}

    {:ok, initial_state}
  end

  @impl true
  def handle_call(start_status, _from, state) do
    running_trace(start_status == :running)
    {:reply, :ok, Map.put(state, :running_status, start_status)}
  end

  @impl true
  def handle_info(
        {:trace_ts, _trace_pid, :call, {m, f, args}, _start_time} = trace_msg,
        state
      ) do
    mfarity = {m, f, length(args)}
    GenServer.cast(Aggregator.mfa_to_name(mfarity), trace_msg)
    {:noreply, state}
  end

  @accepted_return_tags [:return_from, :exception_from]

  @impl true
  def handle_info(
        {:trace_ts, _trace_pid, return_tag, mfa, _TraceTerm, _end_time} = trace_msg,
        state
      )
      when return_tag in @accepted_return_tags do
    GenServer.cast(Aggregator.mfa_to_name(mfa), trace_msg)
    {:noreply, state}
  end

  defp running_trace(bool) do
    :erlang.trace(:all, bool, [:call, :timestamp])
  end
end
