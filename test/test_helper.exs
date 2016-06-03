ExUnit.start

Mix.Task.run "ecto.create", ~w(-r TapRacer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r TapRacer.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(TapRacer.Repo)

