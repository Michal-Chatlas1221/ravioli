ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RavioliWaiter.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RavioliWaiter.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RavioliWaiter.Repo)

