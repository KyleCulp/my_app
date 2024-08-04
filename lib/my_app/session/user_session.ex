defmodule MyApp.Session.UserSession do
  @fields [
    :user_id,
    :session_id,
    :last_active,
    :ip_addresses,
    :user_agent,
    :login_method
  ]

  defstruct @fields
  def fields, do: @fields

  @type t :: %__MODULE__{
          user_id: String.t(),
          session_id: Ash.UUID.t(),
          last_active: integer(),
          ip_addresses: list(String.t()) | nil,
          user_agent: String.t() | nil,
          login_method: String.t()
        }

  # def new(attrs \\ %{}) do
  #   now = DateTime.utc_now() |> DateTime.to_unix()

  #   type = Map.fetch!(:type)

  #   defaults = %{
  #     token: Ash.UUID.generate(),
  #     session_id: Ash.UUID.generate(),
  #     user_id: nil,
  #     inserted_at: now,
  #     expires_at: now + expiration_time(type),
  #     type: nil
  #   }

  #   struct(__MODULE__, Map.merge(defaults, attrs))
  # end
end
