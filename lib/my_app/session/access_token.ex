defmodule MyApp.Session.AccessToken do
  # 15 minutes = 60 seconds * 15 minutes
  @expiration_time 60 * 15

  @fields [
    :token,
    :session_id,
    :user_id,
    :inserted_at,
    :expires_at,
    :last_active
  ]

  defstruct @fields
  def fields, do: @fields

  @type t :: %__MODULE__{
          token: String.t(),
          session_id: String.t(),
          user_id: String.t(),
          inserted_at: integer(),
          expires_at: integer(),
          last_active: integer()
        }

  def new(attrs \\ %{}) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    defaults = %{
      token: MyApp.UUID.generate(),
      session_id: MyApp.UUID.generate(),
      user_id: nil,
      inserted_at: now,
      expires_at: now + @expiration_time,
      last_active: now
    }

    struct(__MODULE__, Map.merge(defaults, attrs))
  end
end
