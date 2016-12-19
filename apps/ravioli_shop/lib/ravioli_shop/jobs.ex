defmodule RavioliShop.Jobs do
  alias RavioliShop.{Repo, User, Job}

  def create_job(user, job_params) do
    user |> Ecto.build_assoc(:jobs)
         |> Job.changeset(job_params)
         |> Repo.insert

    Repo.preload(user, :jobs)
  end

  def update_job(job, jobparams) do
    job |> Job.changeset(jobparams) |> Repo.insert_or_update
    Repo.get(Job, job.id)
  end

  def load_user_jobs(user) do
    user |> Repo.preload(:jobs)
  end

  def get_job(user, id) do
    Repo.get_by(Job, [id: id, user_id: user.id])
  end

  def check_result_update(params) do

  end

  def find_and_delete(user, id) do
    case get_job(user, id) do
      %Job{} = job ->
        job |> Repo.delete
        0
      nil -> 1
    end
  end
end
