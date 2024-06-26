[
  plugins: [Phoenix.LiveView.HTMLFormatter],
  inputs: [
    "mix.exs",
    ".formatter.exs",
    "*.{heex,ex,exs}",
    "{config,lib,test}/**/*.{heex,ex,exs}",
    "priv/*/seeds.exs"
  ],
  subdirectories: ["apps/*"],
  import_deps: [
    :phoenix,
    :ash,
    :ash_postgres,
    :ash_authentication,
    :ash_authentication_phoenix,
    :ash_phoenix
  ]
]
