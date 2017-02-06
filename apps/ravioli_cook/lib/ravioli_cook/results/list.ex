defmodule RavioliCook.Results.List do
  @moduledoc """
  """

  use GenServer

  alias RavioliCook.JobFetcher
  alias RavioliCook.TaskServer
  alias RavioliCook.Results.Reporter

  defmodule Results do
    defstruct results: [], tasks_ids: [], required_results_count: nil,
      start_time: nil, job_id: nil
  end

  def start_link(job_id, required_results_count, start_time \\ nil) do
    GenServer.start_link(__MODULE__, {job_id, required_results_count, start_time}, [])
  end

  def init({job_id, required_results_count, start_time}) do
    start_time = start_time || :os.timestamp()
    RavioliCook.JobFetcher.Server.update_next_start_time(job_id, start_time)
    {:ok, %Results{
        job_id: job_id,
        required_results_count: required_results_count,
        start_time: start_time
     }}
  end

  def handle_cast({:add_result, %{
    "result" => result,
    "task_id" => task_id
  }}, state) do
    new_results = [result | state.results]
    tasks_ids = Enum.uniq([task_id | state.tasks_ids])

    received_count = length(tasks_ids)

    job_id = TaskServer.get(task_id)["job_id"]
    Reporter.report_progress(job_id, state.required_results_count, received_count)

    if received_count == state.required_results_count do
      duration = :timer.now_diff(:os.timestamp, state.start_time)

      results =
        new_results
        |> List.flatten()
        |> Enum.reject(&(is_nil(&1)))
        |> Enum.uniq()

      Reporter.report_results(job_id, results, duration / 1000)
      TaskServer.finish_job(job_id)

      start_next_job(state.job_id, results, state.start_time)

      {:stop, :normal, []}
    else
      TaskServer.remove(task_id)
      new_state = %{state |
                    results: new_results,
                    tasks_ids: tasks_ids
                   }

      {:noreply, new_state}
    end

  end
  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end

  defp start_next_job(job_id, results, start_time) do
    jobs = RavioliCook.JobFetcher.get_jobs()
    job = Enum.find(jobs, fn j -> j.previous_job_id == job_id end)

    case job do
      nil -> nil
      %{} ->

        metadata = %{"previous" => results}
        job_metadata = Poison.decode!(job.metadata)
        new_metadata = Map.merge(job_metadata, metadata) |> Poison.encode!()

        job = %{job | metadata: new_metadata, previous_job_id: nil}

        RavioliCook.JobFetcher.Server.start_job(job)
    end
  end
end
