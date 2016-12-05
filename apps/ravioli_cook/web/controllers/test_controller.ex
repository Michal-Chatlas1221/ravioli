defmodule RavioliCook.TestController do
  use RavioliCook.Web, :controller

  def job(conn, _params) do
    job = RavioliCook.JobFetcher.get_task()
    # script = Tesla.get(job["script_file"]).body

    render(conn, "job.html", job: job, script: "")
  end

  def index(conn, _params) do
    jobs = RavioliCook.JobFetcher.get_jobs()

    render(conn, "index.json", jobs: jobs)
  end

  def show(conn, %{"id" => id}) do
    job =
      RavioliCook.JobFetcher.get_jobs()
      |> Enum.find(&(&1["id"] == id))

    render(conn, "show.json", job: job)
  end
end
