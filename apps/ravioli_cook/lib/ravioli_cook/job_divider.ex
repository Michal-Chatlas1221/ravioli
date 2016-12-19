defmodule RavioliCook.JobDivider do
  alias RavioliCook.Job

  def divide_job_into_tasks(%Job{type: "pi"} = job) do
    Enum.map(1..10, fn _ -> %{
      "job_type" => "pi",
      "job_id" => job.id,
      "rounds" => "1000000"
    } end)
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
