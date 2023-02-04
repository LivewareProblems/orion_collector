defmodule OrionCollectorTest do
  use ExUnit.Case
  doctest OrionCollector

  test "pause_trace" do
    assert OrionCollector.Tracer.pause_trace(nil, false) == :ok
  end
end
