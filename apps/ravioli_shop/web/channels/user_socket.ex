defmodule RavioliShop.UserSocket do
  use Phoenix.Socket

  channel "pi:*", RavioliShop.PiChannel
  channel "result:*", RavioliShop.ResultChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
