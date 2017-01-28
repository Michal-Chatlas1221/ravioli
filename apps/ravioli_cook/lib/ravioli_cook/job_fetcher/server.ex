defmodule RavioliCook.JobFetcher.Server do
  @moduledoc """
  Server fetching the jobs api for existing jobs. After receiving the list,
  it saves the new ones in its state. Makes an API call every `@interval` seconds.
  """
  use GenServer

  alias RavioliCook.JobFetcher.Api
  alias RavioliCook.Tracker.JobTracker
  alias RavioliCook.{JobDivider, Job, TaskServer}

  @name :job_fetcher
  @interval 60_000
  @timeout 20_000
  @jobs_api Application.get_env(:ravioli_cook, :jobs_api, RavioliCook.JobFetcher.Api)

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @doc "Returns the list of current jobs"
  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  def get_job(job_id), do: GenServer.call(@name, {:get_job, job_id})

  # Callbacks
  def init(%{}) do
    Process.send_after(self(), :fetch_jobs, 1_000)
    {:ok, %{jobs: []}}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  def handle_call({:get_job, job_id}, _from, %{jobs: jobs} = state) do
    job = Enum.find(jobs, &(&1.id == job_id))
    {:reply, job, state}
  end

  def handle_info(:fetch_jobs, %{jobs: jobs} = state) do
    fetched_jobs =
      @jobs_api.jobs().body
      |> Enum.map(&Job.from_map/1)
      |> reject_processed_by_other_nodes()

    {new_jobs, new_tasks} = divide_jobs_into_tasks(fetched_jobs -- jobs)

    all_jobs = Enum.uniq_by(jobs ++ new_jobs, &(&1.id))
    TaskServer.add(new_tasks)

    new_state = %{state | jobs: all_jobs}

    interval = :random.uniform(@interval)
    Process.send_after(self(), :fetch_jobs, interval)

    {:noreply, new_state}
  end

  defp divide_jobs_into_tasks(jobs) do
    jobs
    |> Enum.reduce({[], []}, fn (job, {jobs_acc, tasks_acc}) ->
      tasks = JobDivider.divide_job_into_tasks(job)
      tasks_count = length(tasks)

      updated_job = %{job | required_results_count: tasks_count}

      {[updated_job | jobs_acc], tasks ++ tasks_acc}
    end)
  end

  defp reject_processed_by_other_nodes(jobs) do
    Enum.filter(jobs, fn job ->
      IO.inspect job
      case JobTracker.start_job(job) do
        :ok ->
          IO.puts "starting - #{job.id}"
          true
        _ ->
          IO.puts "rejecting - #{job.id}"
          false
      end
    end)
  end
end
