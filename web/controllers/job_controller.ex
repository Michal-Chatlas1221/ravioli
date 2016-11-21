defmodule Ravioli.JobController do
  use Ravioli.Web, :controller
  alias Ravioli.{Repo, User, Job}

  alias Ravioli.ErrorView

  def create(conn, %{"token" => token, "job" => job_params}) do
    case Repo.get_by(User, auth_token: token) do
      %User{} = user -> user
          |> build_assoc(:jobs)
          |> Job.changeset(job_params)
          |> Repo.insert
          user = Repo.preload(user, :jobs)
          render(conn, "index.json", user)
        nil -> conn |> put_status(:unauthorized) |> render(ErrorView, "401.json")
    end                  
  end

  def index(conn, %{"token" => token}) do
    case Repo.get_by(User, auth_token: token) do
      %User{} = user -> 
          conn |> render("index.json", user.jobs)
        nil -> conn |> put_status(:unauthorized) |> render(ErrorView, "401.json")
    end
  end  
end