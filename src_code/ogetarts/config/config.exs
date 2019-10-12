# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ogetarts, OgetartsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "psIjt41y34vA+aO+HuupI5j2GE0ROa/i8tAKiLX+jNPDzuMQHnZeHeR9G+UaQPKI",
  render_errors: [view: OgetartsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ogetarts.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
