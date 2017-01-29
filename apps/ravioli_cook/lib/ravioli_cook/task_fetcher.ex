defmodule RavioliCook.TaskFetcher do
  defdelegate get(), to: RavioliCook.TaskServer
  defdelegate remove(task_id), to: RavioliCook.TaskServer
end
