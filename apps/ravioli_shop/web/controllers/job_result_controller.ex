defmodule RavioliShop.ResultController do
  use RavioliShop.Web, :controller

  def update(conn, %{"job_id" => job_id, "results" => results, "duration" => duration}) do
    RavioliShop.Results.add_result(job_id, results, duration)

    send_resp(conn, 200, "")
  end

  def update(conn, %{"job_id" => job_id, "progress" => progress}) do
    RavioliShop.Results.add_progress(job_id, progress)

    send_resp(conn, 200, "")
  end
end
