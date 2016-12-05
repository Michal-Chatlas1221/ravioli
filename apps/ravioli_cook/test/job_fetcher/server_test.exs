defmodule RavioliCook.JobFetcher.ServerTest do
  use ExUnit.Case

  test "fetches the jobs from jobs API" do
    pid = Process.whereis(:job_fetcher)
    assert %{
      jobs: [%{"id" => "id"}]
    } = :sys.get_state(pid)
  end
end
