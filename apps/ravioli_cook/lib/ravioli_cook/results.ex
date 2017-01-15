defmodule RavioliCook.Results do
  @doc "Abstracts sending the `:add_result` message to genserver"
  def add_result(pid, result) do
    GenServer.cast(pid, {:add_result, result})
  end
end
