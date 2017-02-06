defmodule RavioliShop.Results do
  alias RavioliShop.{Repo, Job}

  def add_result(job_id, result, duration) do
    case Repo.get(Job, job_id) do
      %Job{} = job ->
        job
        |> Job.changeset(%{result: result, duration: duration, progress: 1})
        |> Repo.update
      nil ->
        {:error, :not_found}
    end
  end

  def add_progress(nil, _), do: nil
  def add_progress(job_id, progress) do
    case Repo.get(Job, job_id) do
      %Job{} = job ->
        job
        |> Job.changeset(%{progress: progress})
        |> Repo.update
      nil ->
        {:error, :not_found}
    end
  end
end
