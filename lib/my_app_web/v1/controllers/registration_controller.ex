defmodule MyAppWeb.V1.RegistrationController do
  alias MyAppWeb.V1.Plugs.{SessionHelper, AuthHandler}
  use MyAppWeb, :controller
  alias MyAppWeb.V1.{AshHelpers, JsonApiError}

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, conn, user} <- AuthHandler.create_user(conn, user_params),
         {:ok, conn, _user} <- SessionHelper.create_session(conn, user) do
      conn
      |> put_status(201)
      |> SessionHelper.apply_token_cookie("access_token", conn.private.access_token)
      |> SessionHelper.apply_token_cookie("refresh_token", conn.private.refresh_token)
      |> json(%{
        access_token: conn.private.access_token,
        renewal_token: conn.private.refresh_token,
        user: AshHelpers.resource_to_json(user, [:email, :created_at, :updated_at])
      })
    else
      {:error, conn, errors} ->
        conn
        |> put_status(409)
        |> json(%{
          errors: JsonApiError.transform_ash_errors(errors),
          jsonapi: %{
            version: "1.0"
          }
        })
    end
  end
end
