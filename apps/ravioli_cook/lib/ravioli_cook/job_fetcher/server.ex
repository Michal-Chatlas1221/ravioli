defmodule RavioliCook.JobFetcher.Server do
  use GenServer

  alias RavioliCook.JobFetcher.Api

  @name :job_fetcher

  # Client API
  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_jobs(), do: GenServer.call(@name, :get_jobs)

  # Callbacks
  def init(%{}) do
    Process.send_after(self(), :fetch_jobs, 1_000)
    {:ok, %{jobs: []}}
  end

  def handle_call(:get_jobs, _from, %{jobs: jobs} = state) do
    {:reply, jobs, state}
  end

  def handle_info(:fetch_jobs, %{jobs: jobs} = state) do
    new_jobs =
      jobs ++ Api.jobs().body
      |> Enum.uniq_by(fn %{"id" => id} -> id end)
    new_state = %{state | jobs: new_jobs}
      |> IO.inspect

    Process.send_after(self(), :fetch_jobs, 10_000)

    {:noreply, new_state}
  end
end
