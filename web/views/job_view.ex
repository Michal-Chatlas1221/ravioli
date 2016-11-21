defmodule Ravioli.JobView do
  use Ravioli.Web, :view

  def render("single_job.json", %{"type" => type, "input" => input} = job) do
    %{"type" => type, "input" => input}
  end
end
