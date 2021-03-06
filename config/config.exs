# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :otto, ecto_repos: [Otto.Repo]

# Configures the endpoint
config :otto, OttoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base:
    "otcfYYMFxta2jcyGl/IwmADlq7QWrc+mS8fQjNdqsxMFyoQ7UO1SNgNEc8rEnREF",
  render_errors: [view: OttoWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Otto.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Configures Ueberauth
config :ueberauth, Ueberauth,
  providers: [
    slack: {Ueberauth.Strategy.Slack, [default_scope: "bot,identify"]}
  ]

config :ueberauth, Ueberauth.Strategy.Slack.OAuth,
  client_id: System.get_env("SLACK_CLIENT_ID"),
  client_secret: System.get_env("SLACK_CLIENT_SECRET")

config :juvet, bot: Otto.Bot

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
