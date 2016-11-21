defmodule Ravioli.JobController do
  use Ravioli.Web, :controller
  alias Ravioli.{Repo, User, Job}

  alias Ravioli.ErrorView

  def create(conn, %{"token" => token, "job" => %{"type" => type, "input" => input} = job} = params) do
    case Repo.get_by(User, auth_token: token) do
      %User{} = user -> Ecto.build_assoc(user, :jobs, %{type: type, input: input})
        |> Repo.insert
        render(conn, "single_job.json", job)  
    end                  
  end
end