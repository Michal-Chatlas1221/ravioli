defmodule RavioliCook.Tracker.VectorClock do
  @moduledoc """
  Defines a struct and function for managing vector clocks. The struct has two keys:
  `node` which is a node identifier and `clocks` which are a map of each node's current
  counter value.
  """
  defstruct [:node, :clocks]

  alias RavioliCook.Tracker.VectorClock

  @doc """
  Synchronizes two clocks and increases the first one"

      iex> c1 = %RavioliCook.Tracker.VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 2}}
      iex> c2 = %RavioliCook.Tracker.VectorClock{node: "n2", clocks: %{"n1" => 0, "n2" => 4}}
      iex> RavioliCook.Tracker.VectorClock.update(c1, c2)
      %RavioliCook.Tracker.VectorClock{node: "n1", clocks: %{"n1" => 2, "n2" => 4}}
  """
  def update(%VectorClock{} = current, %VectorClock{} = other) do
    updated_clocks =
      current
      |> merge_clocks(other)
      |> increase_clock(current.node)

    %{current | clocks: updated_clocks}
  end

  defp merge_clocks(current, other) do
    (Map.keys(current.clocks) ++ Map.keys(other.clocks))
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn (node, acc) ->
      Map.merge(acc, %{node => max(current, other, node)})
    end)
  end

  defp increase_clock(clocks, node) do
    increased_value = clocks[node] + 1

    %{clocks | node => increased_value}
  end

  defp max(clock1, clock2, key) do
    value1 = clock1.clocks[key] || 0
    value2 = clock2.clocks[key] || 0

    if value1 > value2, do: value1, else: value2
  end
end
