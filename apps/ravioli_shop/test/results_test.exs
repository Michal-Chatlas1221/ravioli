defmodule RavioliShop.ResultsTest do
  use RavioliShop.ModelCase, async: true

  alias RavioliShop.{Repo, Job, Results, User}

  test "add_result" do
    user = Repo.insert!(%User{})
    job = Repo.insert!(%Job{type: "type", user_id: user.id, input: "input"})

    assert {:ok, %Job{result: "result"}} = Results.add_result(job.id, "result")
  end
end
