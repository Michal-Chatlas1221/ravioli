defmodule RavioliCook.Tracker.ClockServer do
  @moduledoc """
  Keeps track of the current clocks for connected nodes.
  """
  use GenServer

  alias RavioliCook.Tracker.VectorClock

  @name :clock_server

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @doc "Increases counter value for current node and returns the new clock."
  def update(),      do: GenServer.call(@name, :update)
  @doc """
  Synchronizes clock with another one, increases counter value
  for current node and returns the new clock
  """
  def update(other), do: GenServer.call(@name, {:update, other})

  ## Calbacks

  def init([]) do
    {:ok, VectorClock.initialize()}
  end

  def handle_call(:update, _from, clock) do
    new_clock = VectorClock.update(clock)
    {:reply, new_clock, new_clock}
  end

  def handle_call({:update, other}, _from, clock) do
    new_clock = VectorClock.update(clock, other)
    {:reply, new_clock, new_clock}
  end
end
