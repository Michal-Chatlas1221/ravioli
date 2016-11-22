defmodule Ravioli.Jobs do
  alias Ravioli.{Repo, User, Job}

  def create_job(user, job_params) do
    user |> Ecto.build_assoc(:jobs)
         |> Job.changeset(job_params)
         |> Repo.insert
    user = Repo.preload(user, :jobs)
  end

  def load_user_jobs(user) do
    user |> Repo.preload(:jobs)
  end

  def get_job(user, id) do
    Repo.get_by(Job, [id: id, user_id: user.id])
  end
end