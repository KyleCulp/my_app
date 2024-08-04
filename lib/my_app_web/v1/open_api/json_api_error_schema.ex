defmodule MyAppWeb.V1.OpenAPI.JsonApiError do
  require OpenApiSpex

  alias OpenApiSpex.Schema

  @schema OpenApiSpex.schema(%{
            title: "JSON:API Error",
            description: "A JSON:API-compliant error",
            type: :object,
            properties: %{
              id: %Schema{type: :string, nullable: true},
              links: %Schema{type: :object, nullable: true},
              status: %Schema{type: :string},
              code: %Schema{type: :string, nullable: true},
              title: %Schema{type: :string},
              detail: %Schema{type: :string},
              source: %Schema{
                type: :object,
                properties: %{
                  pointer: %Schema{type: :string, nullable: true},
                  parameter: %Schema{type: :string, nullable: true}
                }
              },
              meta: %Schema{
                type: :object,
                properties: %{
                  constraint: %Schema{type: :string, nullable: true},
                  constraint_type: %Schema{
                    type: :string,
                    enum: [:unique, :foreign_key, :check, :exclusion],
                    nullable: true
                  }
                }
              }
            },
            required: [:status, :title]
          })

  def schema, do: @schema
end
