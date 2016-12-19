defmodule RavioliCook.JobDivider.Api do
  def get_tasks(%{divide_server_url: url} = job) do
    resp = Tesla.post(url, "", headers: %{"Content-Type" => "application/json"})

    resp.body
    |> Poison.decode!
    |> Map.get("tasks")
    |> Enum.map(&Map.merge(&1, %{"job_id" => job.id}))
  end
end
