defmodule RavioliShop.Plugs.TrustedService do
  import Plug.Conn

  def init(options), do: options

  def call(%Plug.Conn{} = conn, _options) do
  	IO.inspect("Connection from another service")
  	conn 
  end
end