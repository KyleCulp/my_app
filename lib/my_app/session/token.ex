defmodule MyApp.Session.Token do
  # 15 minutes = 60 seconds * 15 minutes
  @access_token_expiration_time 60 * 15
  # 30 days = 60 seconds * 60 minutes * 24 hours * 7 days * 4 weeks
  @refresh_token_expiration_time 60 * 60 * 24 * 7 * 4

  def access_token_expiration_time, do: @access_token_expiration_time
  def refresh_token_expiration_time, do: @refresh_token_expiration_time

  @fields [
    :token,
    :session_id,
    :user_id,
    :inserted_at,
    :expires_at,
    :type
  ]

  defstruct @fields
  def fields, do: @fields

  @type t :: %__MODULE__{
          token: String.t(),
          session_id: String.t(),
          user_id: String.t(),
          inserted_at: integer(),
          expires_at: integer(),
          type: :access | :refresh
        }

  def new(attrs \\ %{}) do
    now = DateTime.utc_now() |> DateTime.to_unix()

    type = Map.fetch!(attrs, :type)

    defaults = %{
      token: Ash.UUID.generate(),
      session_id: Ash.UUID.generate(),
      user_id: nil,
      inserted_at: now,
      expires_at: now + expiration_time(type),
      type: nil
    }

    struct(__MODULE__, Map.merge(defaults, attrs))
  end

  def expiration_time(:access), do: @access_token_expiration_time
  def expiration_time(:refresh), do: @refresh_token_expiration_time
end
