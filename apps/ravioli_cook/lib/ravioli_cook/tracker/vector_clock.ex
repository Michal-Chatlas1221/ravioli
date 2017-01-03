defmodule RavioliCook.Tracker.VectorClock do
  @moduledoc """
  Defines a struct and function for managing vector clocks. The struct has two keys:
  `node` which is a node identifier and `clocks` which are a map of each node's current
  counter value.
  """
  defstruct [:node, :clocks]

  alias RavioliCook.Tracker.VectorClock

  @doc "Initializes an initial clock for current node"
  def initialize do
    node = Node.self()
    %VectorClock{node: node, clocks: %{node => 1}}
  end

  @doc """
  Synchronizes two clocks and increases the first one"

      iex> c1 = %RavioliCook.Tracker.VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 2}}
      iex> c2 = %RavioliCook.Tracker.VectorClock{node: "n2", clocks: %{"n1" => 0, "n2" => 4}}
      iex> RavioliCook.Tracker.VectorClock.update(c1, c2)
      %RavioliCook.Tracker.VectorClock{node: "n1", clocks: %{"n1" => 2, "n2" => 4}}
  """
  def update(%VectorClock{} = current) do
    updated_clocks = increase_clock(current.clocks, current.node)

    %{current | clocks: updated_clocks}
  end
  def update(%VectorClock{} = current, %VectorClock{} = other) do
    updated_clocks =
      current
      |> merge_clocks(other)
      |> increase_clock(current.node)

    %{current | clocks: updated_clocks}
  end

  @doc """
  Compares two vector clocks. Returns `:gt`, `:lt` or `:error`
  """
  def compare(%VectorClock{} = clock1, %VectorClock{} = clock2) do
    values1 = clock1 |> merge_clocks(clock2) |> Map.values()
    values2 = clock2 |> merge_clocks(clock1) |> Map.values()

    case do_compare(values1, values2, nil) do
      true   -> :gt
      false  -> :lt
      :error -> :error
    end
  end

  defp do_compare([h1 | _] = values1, [h2 | _] = values2, nil) do
    do_compare(values1, values2, h1 > h2)
  end
  defp do_compare([], [], current), do: current
  defp do_compare([h1 | t1], [h2 | t2], current) do
    if h1 > h2 == current do
      do_compare(t1, t2, current)
    else
      :error
    end
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
