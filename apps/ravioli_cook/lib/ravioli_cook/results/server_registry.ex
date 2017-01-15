defmodule RavioliCook.Results.ServerRegistry do
  @moduledoc """
  Keeps a map with PIDs of results servers for each job. If the server does not
  already exists, it starts it and then returns the PID.
  """
  use GenServer

  @name :server_registry

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: @name)
  end

  def get_result_server(job_id), do: GenServer.call(@name, {:get_pid, job_id})

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:get_pid, job_id}, _from, state) do
    case state[job_id] do
      pid when is_pid(pid) ->
        {:reply, pid, state}
      _ ->
        pid = start_result_server(job_id)
        new_state = Map.merge(state, %{job_id => pid})

        {:reply, pid, new_state}
    end
  end
  def handle_call({:get_pid, _}, _from, state) do
    {:reply, :invalid_task_format, state}
  end


  defp start_result_server(job_id) do
    # TODO: Add supervisor for results server
    IO.puts "starting server for #{job_id}"
    {:ok, pid} = RavioliCook.Results.PiServer.start_link()
    pid
  end
end
