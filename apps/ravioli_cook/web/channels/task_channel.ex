defmodule RavioliCook.TaskChannel do
  use RavioliCook.Web, :channel
  alias RavioliCook.JobFetcher

  def join("tasks:*", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("task_request", %{}, socket) do
  	case JobFetcher.get_task() do
      nil -> nil
      tasks ->
        push(socket, "task_response", %{:items => tasks})
    end
    {:noreply, socket}
  end
end
