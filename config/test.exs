use Mix.Config

# Configure your database
config :target_mvd, TargetMvd.Repo,
  username: "postgres",
  password: "postgres",
  database: "target_mvd_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :target_mvd, TargetMvdWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Config mock for mails
config :target_mvd, :confirmation_mailer, TargetMvdWeb.Mailer.InMemory
