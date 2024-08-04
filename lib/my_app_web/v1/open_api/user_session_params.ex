defmodule MyAppWeb.V1.OpenAPI.UserSessionParams do
  require OpenApiSpex

  @schema %OpenApiSpex.Schema{
    title: "UserSessionParams",
    description: "Parameters required for user authentication.",
    type: :object,
    properties: %{
      user: %OpenApiSpex.Schema{
        type: :object,
        properties: %{
          email: %OpenApiSpex.Schema{type: :string, format: :email, description: "User's email"},
          password: %OpenApiSpex.Schema{
            type: :string,
            format: :password,
            description: "User's password"
          }
        },
        required: [:email, :password]
      }
    },
    required: [:user]
  }

  def schema, do: @schema
end
