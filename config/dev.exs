import Config

# Configure your database
config :my_app, MyApp.Repo,
  username: "postgres",
  password: "masterpassword",
  hostname: "postgres-primary",
  database: "my_app_dev",
  port: 5432,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :my_app, :token_signing_secret, "some_super_secret_random_value"
config :ash_authentication, debug_authentication_failures?: true

# Disable open_api cache in development
config :open_api_spex, :cache_adapter, OpenApiSpex.Plug.NoneCache

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we can use it
# to bundle .js and .css sources.
config :my_app, MyAppWeb.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {0, 0, 0, 0}, port: 4000],
  # https: [
  #   port: 4001,
  #   cipher_suite: :strong,
  #   keyfile: "priv/cert/selfsigned_key.pem",
  #   certfile: "priv/cert/selfsigned.pem"
  # ],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "tWXsOHC1yXnm2GTKqr2FMInvJmwJat5wzMYkk1aXzirMuCIXAbu4UwOAYurtFBX7",
  salt: "5HDfH+YT3uxLueFGTsk0Tg==",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:my_app, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:my_app, ~w(--watch)]}
  ]

# Watch static and templates for browser reloading.
config :my_app, MyAppWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/(?!uploads/).*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/my_app_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

# Enable dev routes for dashboard and mailbox
config :my_app, dev_routes: true

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime

config :phoenix_live_view,
  # Include HEEx debug annotations as HTML comments in rendered markup
  debug_heex_annotations: true,
  # Enable helpful, but potentially expensive runtime checks
  enable_expensive_runtime_checks: true

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false
