list = Enum.to_list(1..10_000_000)

ets = :ets.new(:test, [:set, :named_table])
ordered_ets = :ets.new(:test2, [:ordered_set, :named_table])


queue = :queue.new()
queue2 = Enum.reduce(1..10_000_000, queue, fn (el, q) -> :queue.in(el, q) end)
|> IO.inspect



Benchee.run(%{
  "old"    => fn ->
    list1 = Enum.take(list, 25)
    list2 = Enum.drop(list, 25) ++ list1
  end,

  "concat"    => fn ->
    list1 = Enum.take(list, 25)
    list2 = list |> Enum.drop(25) |> Enum.concat(list1)
  end,
  # "queue"    => fn ->

  #   {q2, q3} = :queue.split(25, queue2)
  #   queue2 = Enum.reduce(1..25, q3, fn (el, q) -> :queue.in(el, q) end)
  #   # {list, new_queue} = Enum.reduce(1..25, {[], queue2}, fn (el, {list, q}) ->
  #   #   {{:value, x}, new_q} = :queue.out(q)

  #   #   {[x | list], new_q}
  #   # end)
  #   # queue2 = Enum.reduce(1..25, new_queue, fn (el, q) -> :queue.in(el, q) end)
  #   # |> IO.inspect

  #   # list2 = Enum.drop(25) ++ list1
  # end,
}, concurrency: 8)
