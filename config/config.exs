# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

import_config "env.local.exs"

config :target_mvd,
  ecto_repos: [TargetMvd.Repo]

# Pow configuration for user authentication
config :target_mvd, :pow,
  user: TargetMvd.Users.User,
  repo: TargetMvd.Repo,
  extensions: [PowEmailConfirmation, PowResetPassword],
  mailer_backend: TargetMvdWeb.PowMailer

# Mailer config
config :target_mvd, TargetMvdWeb.PowMailer,
  # Specify your preferred adapter
  adapter: Bamboo.SendGridAdapter,
  # Specify adapter-specific configuration
  api_key: System.get_env("SENDGRID_API_KEY")

# Configures the endpoint
config :target_mvd, TargetMvdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "preFF1928Ui4jUCDfyfs+hqzknxvb+pdcS3oCoresbw2ysfPU2Gn8HyFXzd9uQdk",
  render_errors: [view: TargetMvdWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TargetMvd.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
