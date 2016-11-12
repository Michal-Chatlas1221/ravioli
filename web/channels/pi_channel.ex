defmodule Ravioli.PiChannel do
  use Ravioli.Web, :channel

  def join("pi:monte", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("result", %{"round" => round, "hit" => hit}, socket) do
    pi = (hit / round) * 4
    {:noreply, socket}
  end
end
