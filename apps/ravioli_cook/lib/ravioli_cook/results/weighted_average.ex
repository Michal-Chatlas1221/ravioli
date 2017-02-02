defmodule RavioliCook.Results.WeightedAverage do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  alias RavioliCook.JobFetcher
  alias RavioliCook.TaskServer

  defmodule Results do
    defstruct numerator: 0, denominator: 0, tasks_ids: [],
              required_results_count: nil, start_time: nil
  end

  def start_link(required_results_count) do
    GenServer.start_link(__MODULE__, required_results_count, [])
  end

  def init(required_results_count) do
    start_time = :os.timestamp()
    {:ok, %Results{
        required_results_count: required_results_count,
        start_time: start_time
     }}

  end

  def handle_cast({:add_result, %{
    "numerator" => numerator,
    "denominator" => denominator,
    "task_id" => task_id
  }}, state) do
    numerator = state.numerator + to_int(numerator)
    denominator = state.denominator + to_int(denominator)
    tasks_ids = Enum.uniq([task_id | state.tasks_ids])

    TaskServer.remove(task_id)
    IO.puts "length: #{length(tasks_ids)}"

    if length(tasks_ids) == state.required_results_count do
      IO.puts "result: "
      IO.inspect numerator / denominator
      duration = :timer.now_diff(:os.timestamp, state.start_time)

      IO.puts "duration: #{inspect duration}"
      {:stop, :normal, []}
else
    new_state = %{state |
      numerator: numerator,
      denominator: denominator,
      tasks_ids: tasks_ids
    }

    {:noreply, new_state}

    end


  end
  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(s), do: String.to_integer(s)
end
