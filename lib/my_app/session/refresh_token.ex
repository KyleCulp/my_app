defmodule MyApp.Session.RefreshToken do
  # 30 days = 60 seconds * 60 minutes * 24 hours * 7 days * 4 weeks
  @expiration_time 60 * 60 * 24 * 7 * 4

  @fields [
    :token,
    :session_id,
    :user_id,
    :inserted_at,
    :expires_at,
    :last_active,
    :ip_address,
    :user_agent,
    :login_method
  ]

  defstruct @fields
  def fields, do: @fields

  @type t :: %__MODULE__{
          token: String.t(),
          session_id: String.t(),
          user_id: String.t(),
          inserted_at: integer(),
          expires_at: integer(),
          last_active: integer(),
          ip_address: String.t() | nil,
          user_agent: String.t() | nil,
          login_method: String.t()
        }

  def new(attrs \\ %{}) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    defaults = %{
      token: MyApp.UUID.generate(),
      session_id: MyApp.UUID.generate(),
      user_id: nil,
      inserted_at: now,
      expires_at: now + @expiration_time,
      last_active: now,
      ip_address: nil,
      user_agent: nil,
      login_method: "password"
    }

    struct(__MODULE__, Map.merge(defaults, attrs))
  end
end
