defmodule RavioliCook.JobFetcher.Server do
  @moduledoc """
  Server fetching the jobs api for existing jobs. After receiving the list,
  it saves the new ones in its state. Makes an API call every `@interval` seconds.
  """
  use GenServer

  alias RavioliCook.JobFetcher.Api

  @name :job_fetcher
  @interval 10_000
  @jobs_api Application.get_env(:ravioli_cook, :jobs_api, RavioliCook.JobFetcher.Api)

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  @doc "Returns the list of current jobs"
  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  # Callbacks
  def init(%{}) do
    send(self(), :fetch_jobs)
    {:ok, %{jobs: []}}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  def handle_info(:fetch_jobs, %{jobs: jobs} = state) do
    new_jobs =
      jobs ++ @jobs_api.jobs().body
      |> Enum.uniq_by(fn %{"id" => id} -> id end)
    new_state = %{state | jobs: new_jobs}

    Process.send_after(self(), :fetch_jobs, @interval)

    {:noreply, new_state}
  end
end
