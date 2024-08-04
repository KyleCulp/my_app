defmodule MyAppWeb.V1.JsonAPIRouter do
  @domains [Module.concat(["MyApp.Accounts"]), Module.concat(["MyApp.Todos"])]
  use AshJsonApi.Router,
    domains: @domains,
    json_schema: "/json_schema",
    open_api: "/open_api",
    open_api_title: "MyAppWeb",
    open_api_version: "1.0",
    modify_open_api: {__MODULE__, :modify_open_api, []}

  alias MyAppWeb.V1.OpenAPI.{SessionPaths, RegistrationPaths, UserParams, SessionResponse}

  def modify_open_api(spec, _conn, _opts) do
    additional_paths = [
      SessionPaths.paths(),
      RegistrationPaths.paths()
    ]

    additional_schemas = %{
      "UserRegistrationParams" => MyAppWeb.V1.OpenAPI.UserRegistrationParams.schema(),
      "UserSessionParams" => MyAppWeb.V1.OpenAPI.UserSessionParams.schema(),
      "SessionResponse" => MyAppWeb.V1.OpenAPI.SessionResponse.schema(),
      "JsonApiError" => MyAppWeb.V1.OpenAPI.JsonApiError.schema()
    }

    updated_paths =
      Enum.reduce(additional_paths, spec.paths, fn paths, acc ->
        Map.merge(acc, paths)
      end)

    updated_schemas =
      Map.merge(spec.components.schemas || %{}, additional_schemas)

    updated_components =
      Map.merge(spec.components || %{}, %{schemas: updated_schemas})

    %{
      spec
      | info: %{spec.info | title: "MyApp Title JSON API"},
        paths: updated_paths,
        components: updated_components,
        tags: [
          %{name: "Session", description: "Operations related to user sessions"},
          %{name: "Registration", description: "Operations related to user registration"}
        ]
    }
  end
end
