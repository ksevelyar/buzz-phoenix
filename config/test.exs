import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :buzz, BuzzWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3K6xSle6wv1ORHrfXFxmpkM6gAmX2/PC4f5xEA/V3nC1Px4zvV/JPLHM2c/rbX7J",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
