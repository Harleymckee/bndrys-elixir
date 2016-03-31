ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Bndrys.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Bndrys.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Bndrys.Repo)

