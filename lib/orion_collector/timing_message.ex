defmodule OrionCollector.TimingMessage do
  defstruct args: [],
            result: {:return_from, []},
            time: 0,
            slowest_than: 0
end
