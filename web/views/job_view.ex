defmodule Ravioli.JobView do
  use Ravioli.Web, :view
  alias Ravioli.{Job, User}

  def render("show.json", %Job{} = job) do
  	%{id: job.id, result: job.result, input: job.input, type: job.type}
  end

  def render("index.json", %User{} = user) do
    Enum.map(user.jobs, fn(x) -> render("show.json", x) end)
  end
end
