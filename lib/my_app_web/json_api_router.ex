defmodule MyAppWeb.JsonApiRouter do
  @domains [Module.concat(["MyApp.Accounts"]), Module.concat(["MyApp.Todos"])]
  use AshJsonApi.Router,
    domains: @domains,
    json_schema: "/json_schema",
    open_api: "/open_api"
end
