defmodule MyAppWeb.V1.JsonApiError do
  @enforce_keys [:status, :title]
  defstruct [
    :id,
    :links,
    :status,
    :code,
    :title,
    :detail,
    :source,
    :meta
  ]

  defimpl Jason.Encoder, for: MyAppWeb.V1.JsonApiError do
    def encode(%MyAppWeb.V1.JsonApiError{} = error, opts) do
      error
      |> Map.from_struct()
      # Remove nil values
      |> Enum.reject(fn {_k, v} -> is_nil(v) end)
      |> Map.new()
      |> Jason.Encode.map(opts)
    end
  end

  def transform_ash_errors(%Ash.Error.Invalid{errors: errors}) do
    Enum.map(errors, fn error ->
      %__MODULE__{
        id: Ash.UUID.generate(),
        status: "400",
        title: "Invalid Attribute",
        detail: error.message,
        source: %{
          pointer: "/data/attributes/#{error.field}"
        },
        meta: %{
          constraint: Keyword.get(error.private_vars, :constraint),
          constraint_type: Keyword.get(error.private_vars, :constraint_type)
        }
      }
    end)
  end

  def put_error_status(conn, errors) do
  end
end
