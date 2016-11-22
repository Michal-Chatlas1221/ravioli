defmodule Ravioli.JobController do
  use Ravioli.Web, :controller
  alias Ravioli.{Repo, User, Job}

  alias Ravioli.ErrorView

  def create(conn, job_params) do
    user = conn.assigns.current_user
    user |> build_assoc(:jobs)
         |> Job.changeset(job_params)
         |> Repo.insert
    user = Repo.preload(user, :jobs)
    render(conn, "index.json", user)                 
  end

  def index(conn, %{}) do
    user = conn.assigns.current_user |> Repo.preload(:jobs)
    conn |> render("index.json", user)
  end  
end