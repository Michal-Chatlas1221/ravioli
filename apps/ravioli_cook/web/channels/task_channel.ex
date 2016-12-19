defmodule RavioliCook.TaskChannel do
  use RavioliCook.Web, :channel
  alias RavioliCook.JobFetcher

  def join("tasks:*", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("data_request", %{}, socket) do
  	case JobFetcher.get_task() do
      nil -> nil
      next_task ->
        IO.inspect next_task
        push(socket, "data_response", next_task)
    end
    {:noreply, socket}
  end
end
