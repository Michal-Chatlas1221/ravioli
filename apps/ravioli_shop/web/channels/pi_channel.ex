defmodule RavioliShop.PiChannel do
  @moduledoc """
    Let us not worry about docs right now
  """

  use RavioliShop.Web, :channel

  alias RavioliShop.ResultsServer

  def join("pi:monte", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("result", %{"round" => round, "hit" => hit}, socket) do
    ResultsServer.add_result(hit, round)
    push(socket, "calculate", %{})
    {:noreply, socket}
  end
end
