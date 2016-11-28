# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ravioli_cook, RavioliCook.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "Gf3TElzaTux2k+uXveAvHlH5rEzvNss+77s2j/qmH9vaTQ2dOwHH4YVbJSBSeL+q",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: RavioliCook.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ravioli_cook,
  ecto_repos: [RavioliCook.Repo]  

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
