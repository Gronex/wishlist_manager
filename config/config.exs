# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :wishlist_manager, WishlistManager.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "SuAmdGN1quwxNzHmlBIZYI+3orXdDcQYUYU6ScZl//Y73AIxN8Xg+uQ0df4+MIQ7",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: WishlistManager.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false

config :ueberauth, Ueberauth,
  providers: [
    identity: { Ueberauth.Strategy.Identity, [
      callback_methods: ["POST"],
      uid_field: :username,
    ] },
    google: { Ueberauth.Strategy.Google, [] },
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"), # Needs to be set in env vars
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET") # Needs to be set in env vars

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "wishlist_manager",
  ttl: {30, :days},
  verify_issuer: true, # optional
  secret_key: "super_secret",
  serializer: WishlistManager.GuardianSerializer
