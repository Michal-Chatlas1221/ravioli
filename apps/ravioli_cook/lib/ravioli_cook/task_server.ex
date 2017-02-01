defmodule RavioliCook.TaskServer do
  use GenServer

  @name :task_server
  @timeout 20_000

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  @doc "Add the tasks to the queue"
  def add(tasks), do: GenServer.cast(@name, {:add, tasks})
  @doc "Removes the task from the queue when it's finished"
  def remove(task_id), do: GenServer.cast(@name, {:remove, task_id})
  def get(), do: GenServer.call(@name, :get)

  def init(_) do
    {:ok, []}
  end

  def handle_call(:get, _from, []) do
    {:reply, [], []}
  end
  def handle_call(:get, _from, tasks) when length(tasks) < 26 do
    {:reply, tasks, tasks}
  end
  def handle_call(:get, from, tasks) do
    batch = Enum.take(tasks, 25)
    GenServer.reply(from, batch)
    {:noreply, Enum.drop(tasks, 25) ++ batch}
  end

  def handle_cast({:add, new_tasks}, tasks) do
    {:noreply, tasks ++ new_tasks}
  end

  def handle_cast({:remove, task_id}, tasks) do
    new_tasks = Enum.reject(tasks, &(&1["task_id"] == task_id))
    {:noreply, new_tasks}
  end
end
