# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :tap_racer,
  ecto_repos: [TapRacer.Repo]

# Configures the endpoint
config :tap_racer, TapRacerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VoCAHPEM1OJ7ua1ViTcQGleibCGAo7d65quPCggAAsig/BCqhXVVkbwp2DAdiREP",
  render_errors: [view: TapRacerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TapRacer.PubSub,
  live_view: [signing_salt: "SppfIE9s"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
