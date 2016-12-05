defmodule RavioliCook.JobFetcher.Server do
  @moduledoc """
  Server fetching the jobs api for existing jobs. After receiving the list,
  it saves the new ones in its state. Makes an API call every `@interval` seconds.
  """
  use GenServer

  alias RavioliCook.JobFetcher.Api

  @name :job_fetcher
  @interval 60_000
  @jobs_api Application.get_env(:ravioli_cook, :jobs_api, RavioliCook.JobFetcher.Api)

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @doc "Returns the list of current jobs"
  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  def get_task(), do: GenServer.call(@name, :get_task)

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

  def handle_info(:fetch_jobs, %{jobs: jobs, tasks: tasks} = state) do
    new_jobs_list =
      jobs ++ @jobs_api.jobs().body
      |> Enum.uniq_by(fn %{"id" => id} -> id end)

    new_jobs = new_jobs_list -- jobs

    new_jobs_tasks = divide_jobs_into_tasks(new_jobs)
    new_tasks = tasks ++ new_jobs_tasks

    new_state = %{state | jobs: new_jobs, tasks: new_tasks}

    Process.send_after(self(), :fetch_jobs, @interval)

    {:noreply, new_state}
  end

  defp divide_jobs_into_tasks(jobs) do
    Enum.flat_map(jobs, &divide_job_into_tasks(&1))
  end

  def divide_job_into_tasks(%{"type" => "pi", "id" => id}) do
    Enum.map(1..10, fn _ -> %{"job_type" => "pi", "job_id" => id, "rounds" => "1000000"} end)
  end

  def divide_job_into_tasks(job) do
    %{
      "type" => "multiply",
      "id" => id,
      "input" => input,
      "script_file" => script_file
    } = job

    Poison.decode!(input)
    |> Map.get("matrix_a")
    |> IO.inspect
    |> Stream.with_index()
    |> Enum.map(fn {row, index} ->
      %{
        "job_type" => "multiply",
        "job_id" => id,
        "row" => index,
        "data" => input,
        "script_file" => script_file
      }
    end)
    |> IO.inspect
  end


end
