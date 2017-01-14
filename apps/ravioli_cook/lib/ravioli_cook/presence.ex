defmodule RavioliCook.Presence do
  use Phoenix.Presence, otp_app: :ravioli_cook, pubsub_server: RavioliCook.PubSub
end
