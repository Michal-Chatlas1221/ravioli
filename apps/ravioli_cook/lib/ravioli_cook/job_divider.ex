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
    |> do_divide()
    |> add_common_fields(job)
    |> replicate_tasks(job)
  end

  defp do_divide(%Job{divide_server_url: url} = job) when is_binary(url) do
    Task.Supervisor.start_child(RavioliCook.TaskSupervisor, fn ->
      tasks = JobDivider.Api.get_tasks(job)

      RavioliCook.TaskServer.add(tasks)
    end)

    []
  end

  defp do_divide(%Job{division_type: "list_" <> count} = job) do
    count = String.to_integer(count)

    job.input
    |> Poison.decode!()
    |> Enum.chunk(count)
    |> Stream.with_index()
    |> Enum.map(fn {task_input, index} ->
      %{
        "input" => task_input,
        "job_type" => "lists_#{count}",
        "job_id" => job.id,
        "task_id" => index
      }
    end)
  end


  defp do_divide(%Job{division_type: "two_lists"} = job) do
    [first, second] = Poison.decode!(job.input)

    first_combination = for x <- first, y <- second, do: [x, y]
    # second_combination = for x <- first, y <- second, do: [y, x]
    second_combination = []


    first_combination ++ second_combination
    |> Stream.with_index()
    |> Enum.map(fn {task_input, index} ->
      %{
        "input" => task_input,
        "job_type" => "two_lists",
        "job_id" => job.id,
        "task_id" => index
      }
    end)
    |> IO.inspect
  end

  defp do_divide(
    %Job{division_type: "text_" <> <<separator>> <> "_" <> count} = job
  ) do

    count = String.to_integer(count)
    char_separator = <<separator::utf8>>

    job.input
    |> String.split(char_separator)
    |> Enum.chunk(count)
    |> Stream.with_index()
    |> Enum.map(fn {task_input, index} ->
      %{
        "input" => Enum.join(task_input, char_separator),
        "job_type" => "text_#{char_separator}_#{count}",
        "job_id" => job.id,
        "task_id" => index
      }
    end)
  end

  defp do_divide(%Job{division_type: "repeat_" <> count} = job) do
    Enum.map(1..String.to_integer(count), fn i ->
      %{
        "task_id" => i,
      }
    end)
  end

  defp do_divide(%Job{division_type: "matrix_by_rows"} = job) do
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

  defp do_divide(_), do: []

  defp add_common_fields(tasks, job) do
    common_fields = %{
      "job_id" => job.id,
      "script_file" => job.script_file,
      "task_id" =>  UUID.uuid4(),
      "metadata" => job.metadata
    }
    Enum.map(tasks, fn task -> Map.merge(common_fields, task) end)
  end

  defp permutations([]) do
    [[]]
  end
  defp permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h | t]
  end

  def replicate_tasks(tasks, %{randomized_results: true}), do: tasks
  def replicate_tasks(tasks, %{replication_rate: 0}),       do: tasks
  def replicate_tasks(tasks, %{replication_rate: nil}),       do: tasks
  def replicate_tasks(tasks, %{replication_rate: replication_rate}) do
    length = length(tasks)
    whole_part = replication_rate |> Float.floor() |> round() || 1
    fraction = replication_rate - whole_part

    shuffled = Enum.shuffle(tasks)

    sublist = Enum.take(shuffled, round(length * fraction))
    replicated = shuffled |> List.duplicate(whole_part) |> List.flatten()

    sublist ++ replicated
  end
end
