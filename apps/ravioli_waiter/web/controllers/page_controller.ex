defmodule RavioliWaiter.PageController do
  use RavioliWaiter.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
