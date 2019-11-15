# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :target,
  ecto_repos: [Target.Repo]

# Pow configuration for user authentication
config :target, :pow,
  user: Target.Users.User,
  repo: Target.Repo,
  extensions: [PowEmailConfirmation],
  mailer_backend: TargetWeb.PowMailer

# Mailer config
config :target, TargetWeb.PowMailer,
  # Specify your preferred adapter
  adapter: Bamboo.SendGridAdapter,
  # Specify adapter-specific configuration
  api_key: "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"

# Configures the endpoint
config :target, TargetWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "preFF1928Ui4jUCDfyfs+hqzknxvb+pdcS3oCoresbw2ysfPU2Gn8HyFXzd9uQdk",
  render_errors: [view: TargetWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Target.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
