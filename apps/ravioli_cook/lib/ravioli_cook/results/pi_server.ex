defmodule RavioliCook.Results.PiServer do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  def init(:ok) do
    {:ok, %{hits: 0, rounds: 0}}
  end

  def handle_cast({:add_result, %{"hits" => hits, "rounds" => rounds}}, state) do
    hits = state.hits + to_int(hits)
    rounds = state.rounds + to_int(rounds)

    new_state = %{hits: hits, rounds: rounds}
    IO.puts "current pi value: #{hits * 4 / rounds}"

    {:noreply, new_state}
  end
  def handle_cast({:add_result, _}, state) do
    {:noreply, state}
  end

  def to_int(i) when is_integer(i), do: i
  def to_int(s), do: String.to_integer(s)
end
