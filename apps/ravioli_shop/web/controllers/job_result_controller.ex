defmodule RavioliShop.ResultController do
  use RavioliShop.Web, :controller

  def update(conn, %{"job_id" => job_id, "result" => result}) do
    RavioliShop.Results.add_result(job_id, result)

    send_resp(conn, 200, "")
  end

  def update(conn, %{"job_id" => job_id, "progress" => progress}) do
    RavioliShop.Results.add_progress(job_id, progress)

    send_resp(conn, 200, "")
  end
end
