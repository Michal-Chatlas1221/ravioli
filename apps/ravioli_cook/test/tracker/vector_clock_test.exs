defmodule RavioliCook.Tracker.VectorClockTest do
  use ExUnit.Case, async: true
  doctest RavioliCook.Tracker.VectorClock

  alias RavioliCook.Tracker.VectorClock

  test "initialize" do
    %{node: node, clocks: clocks} = VectorClock.initialize()
    assert %{^node => 1} = clocks
  end

  describe "update" do
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

  describe "compare" do
    test "strictly greater" do
      c1 = %VectorClock{node: "n1", clocks: %{"n1" => 3, "n2" => 1}}
      c2 = %VectorClock{node: "n2", clocks: %{"n1" => 1, "n2" => 1}}

      assert VectorClock.compare(c1, c2) == :gt
    end

    test "strictly smaller" do
      c1 = %VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 1}}
      c2 = %VectorClock{node: "n2", clocks: %{"n1" => 1, "n2" => 3}}

      assert VectorClock.compare(c1, c2) == :lt
    end

    test "other" do
      c1 = %VectorClock{node: "n1", clocks: %{"n1" => 1, "n2" => 1, "n3" => 6}}
      c2 = %VectorClock{node: "n2", clocks: %{"n1" => 1, "n2" => 3, "n3" => 3}}

      assert VectorClock.compare(c1, c2) == :error
      assert VectorClock.compare(c2, c1) == :error
    end
  end
end
