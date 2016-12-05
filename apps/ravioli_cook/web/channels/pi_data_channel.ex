defmodule RavioliCook.PiDataChannel do
  use RavioliCook.Web, :channel
  alias RavioliCook.JobFetcher

  def join("pi:data", _msg, socket) do
    {:ok, socket}
  end

  def handle_in("data_request", %{}, socket) do
  	next_job = JobFetcher.get_first()
  	next_data = map_job_to_task(next_job)
    push(socket, "data_response", next_data)
    {:noreply, socket}
  end
end