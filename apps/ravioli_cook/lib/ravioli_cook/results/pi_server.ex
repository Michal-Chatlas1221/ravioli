defmodule RavioliCook.Results.PiServer do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  @name :pi_results_server

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def add_result(hits, rounds), do:
    GenServer.cast(@name, {:add_result, hits, rounds})

  def init(:ok) do
    {:ok, %{hits: 0, rounds: 0}}
  end

  def handle_cast({:add_result, hits, rounds}, state) do
    hits = state.hits + to_int(hits)
    rounds = state.rounds + to_int(rounds)

    new_state = %{hits: hits, rounds: rounds}
    IO.puts "current pi value: #{hits * 4 / rounds}"

    # Jobs.check_update(new_state)

    {:noreply, new_state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(s), do: String.to_integer(s)
end
