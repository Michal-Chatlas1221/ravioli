defmodule RavioliShop.CookController do
  use RavioliShop.Web, :controller

  def pending(conn, params) do
    jobs = RavioliShop.Repo.all(RavioliShop.Job)
    render(conn, RavioliShop.JobView, "index.json", jobs: jobs)

    # conn |> send_resp(200, "Pending job request")
  end

  def split_status(conn, params) do
     conn |> send_resp(200, "Acknowledged status change")
  end
end
