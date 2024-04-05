# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :vaccination_card, VaccinationCard.Accounts.Auth.Guardian,
  issuer: "vaccination_card",
  secret_key: "N3Xl5p42peFHry6ZERJFY2bzY5u/AuXk1UEJw9NXQgIDZ5kLEWZeZvn+vAz1EFnn"

config :vaccination_card,
  ecto_repos: [VaccinationCard.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :vaccination_card, VaccinationCardWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: VaccinationCardWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: VaccinationCard.PubSub,
  live_view: [signing_salt: "o7IllOMN"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
