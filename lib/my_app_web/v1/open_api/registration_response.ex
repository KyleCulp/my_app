defmodule MyAppWeb.V1.OpenAPI.RegistrationResponse do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  @schema %Schema{
    title: "RegistrationResponse",
    description: "Response containing session tokens",
    type: :object,
    properties: %{
      access_token: %Schema{type: :string, description: "Access token"},
      refresh_token: %Schema{type: :string, description: "Refresh token"},
      user: %Schema{
        type: :object,
        properties: %{
          id: %Schema{type: :string, nullable: true},
          email: %Schema{type: :string, format: :email, description: "User's email"}
        }
      }
    }
  }

  def schema, do: @schema
end
