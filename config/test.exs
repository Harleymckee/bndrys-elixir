use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bndrys, Bndrys.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :bndrys, Bndrys.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL_TEST"},
  pool: Ecto.Adapters.SQL.Sandbox
