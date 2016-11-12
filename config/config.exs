# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ravioli,
  ecto_repos: [Ravioli.Repo]

# Configures the endpoint
config :ravioli, Ravioli.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Ek7Ox88wufQcGGey0e70z+b3Q3SlQGy4/suoYRSZ40uvQGwqBRicmWrvGEmqYeCw",
  render_errors: [view: Ravioli.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ravioli.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
