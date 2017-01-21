defmodule RavioliCook.Tracker.JobTracker do
  @topic "job_tracker"
  alias RavioliCook.Presence

  def start_job(job) do
    Presence.track(self(), @topic, job.id, %{node: Node.self()})

    job_state = get_currently_processed_jobs()[job.id]

    case Enum.find(job_state.metas, fn %{node: node} -> node != Node.self() end) do
      nil -> :ok
      other_node ->
        {:error, :already_started}
    end
  end

  def get_currently_processed_jobs do
    Presence.list(@topic)
  end
end
