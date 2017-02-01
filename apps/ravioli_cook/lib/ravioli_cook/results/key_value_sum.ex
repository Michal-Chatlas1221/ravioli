defmodule RavioliCook.Results.KeyValueSum do
  @moduledoc """
  """

  use GenServer

  alias RavioliCook.JobFetcher
  alias RavioliCook.TaskServer

  defmodule Results do
    defstruct results: %{}, tasks_ids: [], required_results_count: nil
  end

  def start_link(required_results_count) do
    GenServer.start_link(__MODULE__, required_results_count, [])
  end

  def init(required_results_count) do
    {:ok, %Results{required_results_count: required_results_count}}
  end

  def handle_cast({:add_result, %{
    "results" => partial_results,
    "task_id" => task_id
  }}, state) do
    new_results =
      Enum.reduce(partial_results, state.results, fn ({key, value}, acc) ->
        current_values = state.results[key] || []
        new_values     = [{task_id, value} | current_values]
        new_results    = Map.merge(state.results, %{key => new_values})
      end)

    tasks_ids = Enum.uniq([task_id | state.tasks_ids])

    if length(tasks_ids) == state.required_results_count do
      IO.puts "results"
      IO.inspect state.results
    end

    TaskServer.remove(task_id)

    new_state = %{state |
      results: new_results,
      tasks_ids: tasks_ids
    }

    {:noreply, new_state}
  end

  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end
end
