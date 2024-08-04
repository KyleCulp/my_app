defmodule MyAppWeb.V1.OpenAPI.UserRegistrationParams do
  require OpenApiSpex

  @schema %OpenApiSpex.Schema{
    title: "UserRegistrationParams",
    description: "Parameters required for user account registration.",
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
          },
          password_confirmation: %OpenApiSpex.Schema{
            type: :string,
            format: :password,
            description: "User's password confirmation"
          }
        },
        required: [:email, :password, :password_confirmation]
      }
    },
    required: [:user]
  }

  def schema, do: @schema
end
