defmodule RavioliCook.JobFetcher do
  defdelegate get_jobs(), to: RavioliCook.JobFetcher.Server
end