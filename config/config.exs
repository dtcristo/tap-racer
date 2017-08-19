# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :tap_racer, TapRacerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "y5kt3EWkqTzlQ1HdC7k2df5dHKucJC0hKHOG/2WRrkm5tsHf94vAetul4qNuVg9T",
  render_errors: [view: TapRacerWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: TapRacer.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
