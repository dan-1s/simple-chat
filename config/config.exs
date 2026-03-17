import Config

# Configures the endpoint
config :simple_chat, SimpleChatWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "eMD99tu7w1H+z8t1E1sq0RFrNdezTTdy1WWwh/BJNU3xLibWaH0w03GdxvNlMz93",
  render_errors: [
    formats: [html: SimpleChatWeb.ErrorView, json: SimpleChatWeb.ErrorView],
    layout: false
  ],
  pubsub_server: SimpleChat.PubSub

config :simple_chat, :session_options,
  store: :cookie,
  key: "_simple_chat_key",
  signing_salt: "H1SmjnNy"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
