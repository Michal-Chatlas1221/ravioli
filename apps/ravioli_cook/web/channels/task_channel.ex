defmodule RavioliCook.TaskChannel do
  use RavioliCook.Web, :channel
  alias RavioliCook.JobFetcher

  def join("tasks:*", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("task_request", %{}, socket) do
  	case JobFetcher.get_task() do
      nil -> nil
      next_task ->
        push(socket, "task_response", next_task)
    end
    {:noreply, socket}
  end
end
