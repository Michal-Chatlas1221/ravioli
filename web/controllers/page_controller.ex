defmodule Ravioli.PageController do
  use Ravioli.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
