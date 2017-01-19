defmodule RavioliCook.JobFetcher.Server do
  @moduledoc """
  Server fetching the jobs api for existing jobs. After receiving the list,
  it saves the new ones in its state. Makes an API call every `@interval` seconds.
  """
  use GenServer

  alias RavioliCook.JobFetcher.Api
  alias RavioliCook.{JobDivider, Job}

  @name :job_fetcher
  @interval 60_000
  @jobs_api Application.get_env(:ravioli_cook, :jobs_api, RavioliCook.JobFetcher.Api)

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @doc "Returns the list of current jobs"
  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  def get_job(job_id), do: GenServer.call(@name, {:get_job, job_id})

  def get_task(), do: GenServer.call(@name, :get_task)
  def remove_task(task_id), do: GenServer.cast(@name, {:remove_task, task_id})

  def add_tasks(tasks), do: GenServer.cast(@name, {:add_tasks, tasks})

  # Callbacks
  def init(%{}) do
    send(self(), :fetch_jobs)
    {:ok, %{jobs: [], tasks: []}}
  end

  def handle_call(:get_task, _from, %{tasks: []} = state) do
    {:reply, nil, state}
  end
  def handle_call(:get_task, _from, %{tasks: [task | rest]} = state) do
    IO.puts "get #{task["task_id"]}"
    new_state = %{state | tasks: rest ++ [task]}
    {:reply, task, new_state}
  end

  def handle_cast({:remove_task, task_id}, %{tasks: tasks} = state) do
    IO.puts "remove - #{task_id}"
    new_tasks = Enum.reject(tasks, &(&1["task_id"] == task_id))

    {:noreply, %{state | tasks: new_tasks}}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  def handle_call({:get_job, job_id}, _from, %{jobs: jobs} = state) do
    job = Enum.find(jobs, &(&1.id == job_id))
    {:reply, job, state}
  end

  def handle_info(:fetch_jobs, %{jobs: jobs, tasks: tasks} = state) do
    # TODO: Check if job should be processed
    fetched_jobs = Enum.map(@jobs_api.jobs().body, &Job.from_map/1)

    {new_jobs, new_tasks} = divide_jobs_into_tasks(fetched_jobs)

    all_jobs = Enum.uniq_by(jobs ++ new_jobs, &(&1.id))
    all_tasks = tasks ++ new_tasks
    new_state = %{state | jobs: all_jobs, tasks: all_tasks}

    Process.send_after(self(), :fetch_jobs, @interval)

    {:noreply, new_state}
  end

  def handle_cast({:add_tasks, tasks}, state) do
    new_tasks = state.tasks ++ tasks
    new_state = %{state | tasks: tasks}

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


  def duplicate_each_task([], acc), do: acc
  def duplicate_each_task([h | t], acc), do: duplicate_each_task(t, [h, h | acc])
end
