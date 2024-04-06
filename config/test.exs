import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :vaccination_card, VaccinationCard.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "vaccination_card_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  sandbox: true

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vaccination_card, VaccinationCardWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3uNb5r2hmic39nLc6YCI9RY99AsnlPpv308Efr65J4T+2N0CoVYIiZMHF+3ZMnBm",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
