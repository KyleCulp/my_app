defmodule MyAppWeb.V1.SessionController do
  use MyAppWeb, :controller
  alias MyApp.Session
  alias Plug.Conn
  alias MyAppWeb.V1.{AshHelpers, JsonApiError}
  alias MyAppWeb.V1.Plugs.{SessionHelper, AuthHandler}

  @spec create(Conn.t(), map()) :: Conn.t()
  def create(conn, %{"user" => user_params}) do
    with {:ok, conn, user} <- AuthHandler.authenticate_user(conn, user_params),
         {:ok, conn, user} <- AuthHandler.create_session(conn, user) do
      conn
      |> put_status(200)
      # |> SessionHelper.apply_token_cookie("access_token", conn.private.access_token)
      # |> SessionHelper.apply_token_cookie("refresh_token", conn.private.refresh_token)
      |> json(%{
        access_token: conn.private.access_token,
        refresh_token: conn.private.refresh_token,
        access_token_expires_at: conn.private.access_token_expires_at,
        refresh_token_expires_at: conn.private.refresh_token_expires_at,
        user: AshHelpers.resource_to_json(user, [:email, :created_at, :updated_at])
      })
    else
      {:error, conn, _error} ->
        # No need to return detailed errors for failed login
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})
    end
  end

  @spec renew(Conn.t(), map()) :: Conn.t()
  def renew(conn, _params) do
    with [refresh_token] <- Conn.get_req_header(conn, "x-refresh-token"),
         {:ok, conn} <- SessionHelper.renew(conn, refresh_token) do
      conn
      |> put_status(200)
      |> json(%{
        access_token: conn.private.access_token,
        access_token_expires_at: conn.private.access_token_expires_at
      })
    else
      {:error, :expired, conn} ->
        conn
        |> put_status(409)
        |> json(%{
          error: "Refresh token expired"
        })

      err ->
        IO.inspect(err)
        # conn
        # |> json(%{
        #   access_token: conn.private.access_token
        # })
    end

    # IO.inspect(conn)

    conn
    |> json(%{
      access_token: "xd"
    })
  end

  @spec delete(Conn.t(), map()) :: Conn.t()
  def delete(conn, _params) do
    conn
    |> AuthHandler.delete()
    |> json(%{data: %{}})
  end

  def show(conn, _params) do
    # IO.inspect(conn)
    conn |> json(%{xd: ~c"xd"})
  end
end
