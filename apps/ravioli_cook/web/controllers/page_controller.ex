defmodule RavioliCook.PageController do
  use RavioliCook.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
