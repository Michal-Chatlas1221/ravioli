defmodule RavioliCook.Results.Reporter do
  use GenServer

  @name :results_reporter

  alias RavioliCook.Results

  def start_link do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def init(_) do
    {:ok, nil}
  end

  def report_progress(job_id, required, received) do
    GenServer.cast(@name, {:report_progress, job_id, received, required})
  end

  def handle_cast({:report_progress, job_id, received, required}, state) do
    batch_size = div(required, 50)

    if rem(received, batch_size) == 0 do
      progress = received / required
      Results.Api.send_progress(job_id, progress)
    end

    {:noreply, state}
  end
end
