defmodule RavioliCook.TestController do
  use RavioliCook.Web, :controller

  def job(conn, _params) do
    job = RavioliCook.JobFetcher.get_jobs() |> Enum.random()
    script = Tesla.get(job["script_file"]).body

    render(conn, "job.html", job: job, script: script)
  end
end
