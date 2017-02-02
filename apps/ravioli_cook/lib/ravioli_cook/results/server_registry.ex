defmodule RavioliCook.Results.ServerRegistry do
  @moduledoc """
  Keeps a map with PIDs of results servers for each job. If the server does not
  already exists, it starts it and then returns the PID.
  """
  use GenServer

  alias RavioliCook.Results

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
    job = RavioliCook.JobFetcher.get_job(job_id)

    {:ok, pid} = do_start_server(job)
    pid
  end

  defp do_start_server(%{aggregation_type: "weighted_average"} = job) do
    Results.WeightedAverage.start_link(job.required_results_count)
  end

  defp do_start_server(%{aggregation_type: "key_value"} = job) do
    Results.KeyValue.start_link(job.required_results_count)
  end

  defp do_start_server(%{aggregation_type: "key_value_sum"} = job) do
    Results.KeyValueSum.start_link(job.required_results_count)
  end

  defp do_start_server(%{aggregation_type: "list"} = job) do
    Results.List.start_link(job.id, job.required_results_count, job.start_time)
  end

  defp do_start_server(%{aggregation_type: "sum"} = job) do
    Results.Sum.start_link(job.required_results_count)
  end

  defp do_start_server(_), do: {:ok, nil}
end
