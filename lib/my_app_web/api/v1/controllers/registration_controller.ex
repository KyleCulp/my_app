defmodule MyAppWeb.API.V1.RegistrationController do
  use MyAppWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias MyAppWeb.API.V1.ErrorHelpers

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    conn
    |> register_user_with_password(user_params)
    |> case do
      {:ok, user, conn} ->
        conn
        |> json(%{
          data: %{
            access_token: conn.private.api_access_token,
            renewal_token: conn.private.api_renewal_token
            # user: user
          }
        })

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(500)
        |> json(%{error: %{status: 500, message: "Couldn't create user", errors: errors}})
    end
  end

  defp register_user_with_password(conn, user_params) do
    MyApp.Accounts.User
    |> Ash.Changeset.new()
    |> Ash.Changeset.for_create(:register_with_password, user_params)
    |> Ash.create()
    |> maybe_create_auth(conn, user_params)
  end

  defp maybe_create_auth({:ok, user}, conn, user_params) do
    Pow.Plug.authenticate_user(conn, user_params)
    {:ok, user, conn}
  end

  defp maybe_create_auth({:error, changeset}, conn) do
    {:error, changeset, conn}
  end
end
