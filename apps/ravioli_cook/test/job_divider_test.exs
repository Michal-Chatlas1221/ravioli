defmodule RavioliCook.JobDividerTest do
  use ExUnit.Case, async: true

  alias RavioliCook.{JobDivider, Job}

  describe "type: list" do
    test "divides input into list of given size" do
      input = (1..10) |> Enum.to_list() |> Poison.encode!()
      job = %Job{input: input, division_type: "list_5"}

      [t1, t2] = JobDivider.divide_job_into_tasks(job)
      assert [1, 2, 3, 4, 5]  = t1["input"]
      assert [6, 7, 8, 9, 10] = t2["input"]
    end
  end
end
