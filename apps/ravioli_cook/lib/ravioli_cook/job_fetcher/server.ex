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
    new_state = %{state | tasks: rest}
    {:reply, task, new_state}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  def handle_call({:get_job, job_id}, _from, %{jobs: jobs} = state) do
    job = Enum.find(jobs, &(&1.id == job_id))
    {:reply, job, state}
  end

  def handle_info(:fetch_jobs, %{jobs: jobs, tasks: tasks} = state) do

    new_jobs_list =
      jobs ++ Enum.map(@jobs_api.jobs().body, &Job.from_map/1)
      |> Enum.uniq_by(&(&1.id))

    new_jobs = new_jobs_list -- jobs

    new_jobs_tasks = divide_jobs_into_tasks(new_jobs)
    new_tasks = tasks ++ new_jobs_tasks

    new_state = %{state | jobs: new_jobs, tasks: new_tasks}

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
    |> Enum.flat_map(&JobDivider.divide_job_into_tasks(&1))
  end


  def duplicate_each_task([], acc), do: acc
  def duplicate_each_task([h | t], acc), do: duplicate_each_task(t, [h, h | acc])
end
