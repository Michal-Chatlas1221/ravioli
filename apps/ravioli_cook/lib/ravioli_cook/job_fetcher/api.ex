defmodule RavioliCook.JobFetcher.Api do
  use Tesla

  plug Tesla.Middleware.BaseUrl, Application.get_env(:ravioli_cook, :shop_url)
  plug Tesla.Middleware.JSON

  def jobs() do
    get("/cook/pending")
  end
end
