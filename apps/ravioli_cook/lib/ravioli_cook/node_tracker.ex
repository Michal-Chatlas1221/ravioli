defmodule RavioliCook.NodeTracker do
  use GenServer

  @name :node_tracker
  @heartbeat_time 1000

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init([]) do
    send(self(), :monitor_nodes)
    {:ok, []}
  end

  def handle_info(:monitor_nodes, current_nodes) do
    nodes = Node.list()
    new_nodes = nodes -- current_nodes

    Enum.each(new_nodes, fn node -> Node.monitor(node, true) end)

    Process.send_after(self(), :monitor_nodes, @heartbeat_time)

    {:noreply, nodes}
  end

  def handle_info({:nodedown, node}, nodes) do
    IO.puts "node down #{node}"

    {:noreply, nodes -- [node]}
  end

  def handle_info(msg, state) do
    {:ok, state}
  end
end
