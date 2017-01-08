defmodule RavioliShop.Results do
  alias RavioliShop.{Repo, Job}

  def add_result(job_id, result) do
    case Repo.get(Job, job_id) do
      %Job{} = job ->
        job |> Job.changeset(%{result: result}) |> Repo.update
      nil ->
        {:error, :not_found}
    end
  end
end
