defmodule RavioliShop.ResultsServer do
  @moduledoc """
    Let us not worry about docs right now
  """

  use GenServer

  @name :results_server

  def start_link() do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end

  def add_result(hits, rounds), do:
    GenServer.cast(@name, {:add_result, hits, rounds})

  def init(:ok) do
    {:ok, %{hits: 0, rounds: 0}}
  end

  def handle_cast({:add_result, hits, rounds}, state) do
    hits = state.hits + hits
    rounds = state.rounds + rounds

    IO.puts (hits / rounds) * 4
    new_state = %{hits: hits, rounds: rounds}
    {:noreply, new_state}
  end
end