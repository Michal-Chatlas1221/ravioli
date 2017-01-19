defmodule RavioliCook.Results.WeightedAverage do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  alias RavioliCook.JobFetcher

  defmodule Results do
    defstruct numerator: 0, denominator: 0, tasks_ids: [],
              required_results_count: nil
  end

  def start_link(required_results_count) do
    GenServer.start_link(__MODULE__, required_results_count, [])
  end

  def init(required_results_count) do
    {:ok, %Results{required_results_count: required_results_count}}
  end

  def handle_cast({:add_result, %{
    "numerator" => numerator,
    "denominator" => denominator,
    "task_id" => task_id
  }}, state) do
    numerator = state.numerator + to_int(numerator)
    denominator = state.denominator + to_int(denominator)
    tasks_ids = Enum.uniq([task_id | state.tasks_ids])

    IO.puts length(tasks_ids)

    if length(tasks_ids) == state.required_results_count do
      IO.puts "current value: #{numerator / denominator}"
    end

    JobFetcher.remove_task(task_id)

    new_state = %{state |
      numerator: numerator,
      denominator: denominator,
      tasks_ids: tasks_ids
    }

    {:noreply, new_state}
  end
  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(s), do: String.to_integer(s)
end
