defmodule MyApp.OpenApi do
  alias OpenApiSpex.{OpenApi, Info, Server, Components}

  def spec do
    %OpenApi{
      info: %Info{
        title: "MyApp JSON API",
        version: "1.1"
      },
      servers: [
        Server.from_endpoint(MyAppWeb.Endpoint)
      ],
      paths: AshJsonApi.OpenApi.paths(MyApp.Api),
      tags: AshJsonApi.OpenApi.tags(MyApp.Api),
      components: %Components{
        responses: AshJsonApi.OpenApi.responses(),
        schemas: AshJsonApi.OpenApi.schemas(MyApp.Api)
      }
    }
  end
end
