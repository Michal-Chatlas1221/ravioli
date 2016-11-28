defmodule RavioliShop.PageController do
  use RavioliShop.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
