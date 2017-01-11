defmodule RavioliCook.Tracker do
  @topic "job_tracker"
  alias RavioliCook.Presence

  def start_job(job) do
    case Presence.track(self(), @topic, job.id, %{node: Node.self()}) do
      {:ok, _} ->
        :ok
      {:error, {:already_tracked, _, _, _}} ->
        {:error, :already_processed}
    end
  end

  def get_currently_processed_jobs do
    Presence.list(@topic)
  end
end
