defmodule MyAppWeb.V1.OpenAPI.SessionResponse do
  require OpenApiSpex
  alias OpenApiSpex.{Schema, Reference}

  @schema %Schema{
    title: "SessionResponse",
    description: "Response containing session tokens",
    type: :object,
    properties: %{
      access_token: %Schema{type: :string, description: "Access token"},
      refresh_token: %Schema{type: :string, description: "Refresh token"},
      access_token_expires_at: %Schema{
        type: :number,
        description: "Access Token Expiration Unix Time"
      },
      refresh_token_expires_at: %Schema{
        type: :number,
        description: "Refresh Token Expiration Unix Time"
      },
      user: %Reference{"$ref": "#/components/schemas/user"}
    },
    required: [
      :access_token,
      :refresh_token,
      :access_token_expires_at,
      :refresh_token_expires_at,
      :user
    ]
  }

  def schema, do: @schema
end
