ExUnit.configure(formatters: [JUnitFormatter, ExUnit.CLIFormatter])
ExUnit.start()
Faker.start()
Ecto.Adapters.SQL.Sandbox.mode(TargetMvd.Repo, :manual)
