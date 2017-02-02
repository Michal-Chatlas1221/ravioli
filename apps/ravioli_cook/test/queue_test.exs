defmodule RavioliCook.QueueTest do
  use ExUnit.Case


  test "adding" do
    q = :queue.new()

    q2 = Enum.reduce((1..25), q, fn (el, q) -> :queue.in(el, q) end)

    assert :queue.len(q2) == 25
  end

  test "removing" do
    q = :queue.new()

    q2 = Enum.reduce((1..5), q, fn (el, q) -> :queue.in(el, q) end)

    assert {{:value, 1}, _} = :queue.out(q2)
    assert {{:value, 5}, _} = :queue.out_r(q2)
  end

  test "round robin" do

    q = :queue.new()

    q2 = Enum.reduce((1..5), q, fn (el, q) -> :queue.in(el, q) end)
    {{:value, 1}, q3} = :queue.out(q2)
    {{:value, 2}, q4} = :queue.out(q3)


    q5 = :queue.in(1, q4)
    q6 = :queue.in(2, q5)

    {{:value, 3}, q} = :queue.out(q6)
    {{:value, 4}, q} = :queue.out(q)
    {{:value, 5}, q} = :queue.out(q)
    {{:value, 1}, q} = :queue.out(q)
    {{:value, 2}, q} = :queue.out(q)
  end
end
