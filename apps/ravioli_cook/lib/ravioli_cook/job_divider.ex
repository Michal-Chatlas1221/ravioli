defmodule RavioliCook.JobDivider do
  @moduledoc """
  Used to divide job into multiple tasks performed by the users' browsers.
  - When the `divide_server_url` parameter is set for a job, makes a POST request
  to a given url with `RavioliCook.Job` struct encoded in JSON. Expects a json
  representation of `RavioliCook.Task` list.
  - If `divide_server_url` is not set, it divides the job based on its `type`.
  Currently supported types are `"pi"`, `"matrix_by_rows"`, `"list_n"`.
  """
  alias RavioliCook.{JobDivider, Job}

  def divide_job_into_tasks(job) do
    job
    |> do_divide_job_into__tasks()
    |> add_common_fields(job)
  end


  defp do_divide_job_into__tasks(%Job{divide_server_url: url} = job) when is_binary(url) do
    Task.Supervisor.start_child(RavioliCook.TaskSupervisor, fn ->
      tasks = JobDivider.Api.get_tasks(job)

      RavioliCook.JobFetcher.Server.add_tasks(tasks)
    end)

    []
  end

  defp do_divide_job_into__tasks(%Job{division_type: "list_" <> count} = job) do
    count = String.to_integer(count)

    job.input
    |> Poison.decode!()
    |> Enum.chunk(count)
    |> Stream.with_index()
    |> Enum.map(fn {task_input, index} ->
      %{
        "input" => task_input,
        "job_type" => "list_#{count}",
        "job_id" => job.id,
        "task_index" => index
      }
    end)
  end

  defp do_divide_job_into__tasks(%Job{division_type: "pi"} = job) do
    Enum.map(1..80, fn i ->
      %{
        "job_type" => "pi",
        "rounds" => "1000000",
        "task_index" => i,
      }
    end)
  end

  defp do_divide_job_into__tasks(%Job{division_type: "matrix_by_rows"} = job) do
    %{input: input, script_file: script_file} = job

    input
    |> Poison.decode!()
    |> Map.get("matrix_a")
    |> Stream.with_index()
    |> Enum.map(fn {_row, index} ->
      %{
        "job_type"    => "matrix_by_rows",
        "row"         => index,
        "data"        => input,
      }
    end)
  end

  defp do_divide_job_into__tasks(_), do: []

  defp add_common_fields(tasks, job) do
    common_fields = %{
      "job_id" => job.id,
      "script_file" => job.script_file
    }
    Enum.map(tasks, fn task -> Map.merge(task, common_fields) end)
  end
end
