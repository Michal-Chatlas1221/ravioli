defmodule RavioliCook.JobFetcher do
  defdelegate get_jobs(), to: RavioliCook.JobFetcher.Server
  defdelegate get_job(job_id), to: RavioliCook.JobFetcher.Server
  defdelegate get_task(), to: RavioliCook.JobFetcher.Server
  defdelegate remove_task(task_id), to: RavioliCook.JobFetcher.Server
end
