defmodule Ravioli.JobController do
  use Ravioli.Web, :controller
  alias Ravioli.{ErrorView, Jobs, Job}

  def create(conn, job_params) do
    user = conn.assigns.current_user
    user = user |> Jobs.create_job(job_params)
    render(conn, "index.json", user)                 
  end

  def index(conn, %{}) do
    user = conn.assigns.current_user |> Jobs.load_user_jobs()
    conn |> render("index.json", user)
  end

  def show(conn, %{}) do
    case Jobs.get_job(conn.assigns.current_user, conn.params["id"]) do
      nil          -> conn |> put_status(:not_found) |> render(ErrorView, "404.json")
      %Job{} = job -> conn |> render("show.json", job)
    end   
  end

  def update(conn, job_params) do 
    case Jobs.get_job(conn.assigns.current_user, conn.params["id"]) do
      nil          -> conn |> put_status(:not_found) |> render(ErrorView, "404.json")
      %Job{} = job ->
        job = job |> Jobs.update_job(job_params) 
        conn |> render("show.json", job)
    end  
  end

  def delete(conn, %{}) do 
    case Jobs.find_and_delete(conn.assigns.current_user, conn.params["id"]) do 
      0 = status -> conn |> send_resp(200, "OK")
      status = status -> conn |> put_status(:not_found)  |> render(ErrorView, "404.json")
    end  
  end 
end