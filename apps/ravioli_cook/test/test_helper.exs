ExUnit.start

Mix.Task.run "ecto.create", ~w(-r RavioliCook.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r RavioliCook.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(RavioliCook.Repo)

