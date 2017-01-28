defmodule RavioliCook.Tracker.JobTracker do
  @topic "job_tracker"
  alias RavioliCook.Presence

  def start_job(job) do
    case Presence.track(self(), @topic, job.id, %{node: Node.self()}) do
      {:error, _} -> {:error, :already_started}
      _ ->
        job_state = get_currently_processed_jobs()[job.id]

        case Enum.find(job_state.metas, fn %{node: node} -> node != Node.self() end) do
          nil -> :ok
          _other_node ->
            {:error, :already_started}
        end
    end

  end

  def get_currently_processed_jobs do
    Presence.list(@topic)
  end
end
