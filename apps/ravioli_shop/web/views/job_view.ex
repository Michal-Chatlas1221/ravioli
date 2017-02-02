defmodule RavioliShop.JobView do
  use RavioliShop.Web, :view
  alias RavioliShop.{Job, User, ScriptFile}

  def render("show.json", %Job{} = job) do
  	%{
      id: job.id,
      result: job.result,
      input: job.input,
      type: job.type,
      # script_file: file_path(job.script_file),
      script_file: job.script_file,
      divide_server_url: job.divide_server_url,
      division_type: job.division_type,
      aggregation_type: job.aggregation_type,
      replication_rate: job.replication_rate,
      randomized_results: job.randomized_results,
      metadata: job.metadata,
      previous_job_id: job.previous_job_id
    }
  end

  def render("index.json", %User{} = user) do
    Enum.map(user.jobs, fn(x) -> render("show.json", x) end)
  end
  def render("index.json", %{jobs: jobs}) do
    Enum.map(jobs, fn(x) -> render("show.json", x) end)
  end

  defp file_path(file) do
    RavioliShop.Endpoint.url <> "/uploads/jobs/scripts/" <> file.file_name
  end
end
