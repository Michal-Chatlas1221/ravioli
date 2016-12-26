defmodule RavioliCook.Tracker.VectorClockTest do
  use ExUnit.Case, async: true
  doctest RavioliCook.Tracker.VectorClock

  alias RavioliCook.Tracker.VectorClock

  test "for smaller clock" do
    v1 = %VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 1}}
    v2 = %VectorClock{node: "n2", clocks: %{"n1" => 0, "n2" => 1}}

    new = VectorClock.update(v1, v2)

    assert %{"n1" => 2, "n2" => 1} = new.clocks
  end

  test "for greater clock" do
    v1 = %VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 1}}
    v2 = %VectorClock{node: "n2", clocks: %{"n1" => 0, "n2" => 2}}

    new = VectorClock.update(v1, v2)

    assert %{"n1" => 2, "n2" => 2} = new.clocks
  end
end
