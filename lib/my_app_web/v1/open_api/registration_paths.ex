defmodule MyAppWeb.V1.OpenAPI.RegistrationPaths do
  require OpenApiSpex

  alias OpenApiSpex.{Operation, RequestBody, Response, Schema}

  @create %Operation{
    summary: "Create a user account",
    tags: ["Registration"],
    requestBody: %RequestBody{
      description: "User registration parameters",
      content: %{
        "application/vnd.api+json" => %{
          "schema" => %{"$ref" => "#/components/schemas/UserRegistrationParams"}
        }
      }
    },
    responses: %{
      200 => %Response{
        description: "Session response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %{"$ref" => "#/components/schemas/SessionResponse"}
          }
        }
      },
      401 => %Response{
        description: "Error response",
        content: %{
          "application/vnd.api+json" => %{
            "schema" => %{"$ref" => "#/components/schemas/JsonApiError"}
          }
        }
      }
    }
  }

  def paths do
    %{
      "/api/v1/register": %{
        post: @create
      }
    }
  end
end
