# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :grapevine,
  ecto_repos: [Grapevine.Repo]

# Configures the endpoint
config :grapevine, GrapevineWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kftoLfZSJuM0dEd15gA1lcHD1aJFCW/i2sbj5HsgYDBWwkSPcjfhw+9pFI9uBy8m",
  render_errors: [view: GrapevineWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Grapevine.PubSub,
  live_view: [signing_salt: "mzVV8hnu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
