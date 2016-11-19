defmodule Ravioli.PiChannel do
  use Ravioli.Web, :channel

  alias Ravioli.ResultsServer

  def join("pi:monte", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("result", %{"round" => round, "hit" => hit}, socket) do
    ResultsServer.add_result(hit, round)
    push(socket, "calculate", %{})
    {:noreply, socket}
  end
end
