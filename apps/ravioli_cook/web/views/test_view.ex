defmodule RavioliCook.TestView do
  use RavioliCook.Web, :view

  def render("index.json", %{jobs: jobs}) do
    render_many(jobs, RavioliCook.TestView, "job.json", as: :job)
  end

  def render("show.json", %{job: job}) do
    render_one(job, RavioliCook.TestView, "job.json", as: :job)
  end

  defp render("job.json", %{job: job}), do: job
end
