defmodule RavioliShop.Endpoint do

  use Phoenix.Endpoint, otp_app: :ravioli_shop

  socket "/socket", RavioliShop.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ravioli_key",
    signing_salt: "ULbf0050"


  plug Corsica, origins: "*", allow_headers: ["x-auth-token", "content-type"]

  plug Plug.Static,
    at: "/", from: :ravioli_shop, gzip: false,
    only: ~w(css fonts uploads images js favicon.ico robots.txt)

  # plug Corsica,
  #   origins: "*",
  #   allow_headers: ["x-auth-token", "origin", "Content-Type"]

  plug RavioliShop.Router
end
