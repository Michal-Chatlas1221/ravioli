defmodule RavioliCook.JobDivider do
  alias RavioliCook.{JobDivider, Job}

  def divide_job_into_tasks(%Job{divide_server_url: url} = job) when is_binary(url) do
    Task.Supervisor.start_child(RavioliCook.TaskSupervisor, fn ->
      tasks = JobDivider.Api.get_tasks(job)

      RavioliCook.JobFetcher.Server.add_tasks(tasks)
    end)

    []
  end

  def divide_job_into_tasks(%Job{type: "pi"} = job) do
    Enum.map(1..10, fn _ ->
      %{
        "job_type" => "pi",
        "job_id" => job.id,
        "rounds" => "1000000"
      }
    end)
  end

  def divide_job_into_tasks(%Job{type: "matrix_by_rows"} = job) do
    %{id: id, input: input, script_file: script_file} = job

    input
    |> Poison.decode!()
    |> Stream.with_index()
    |> Enum.map(fn {_row, index} ->
      %{
        "job_type"    => "matrix_by_rows",
        "job_id"      => id,
        "row"         => index,
        "data"        => input,
        "script_file" => script_file
      }
    end)
  end

  def divide_job_into_tasks(_), do: []
end
