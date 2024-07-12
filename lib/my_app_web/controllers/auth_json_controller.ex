defmodule MyAppWeb.AuthJsonController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller
  require AshAuthentication.Plug

  def success(conn, _activity, _user, token) do
    conn
    |> put_status(200)
    |> json(%{
      authentication: %{
        status: :success,
        bearer: token
      }
    })
  end

  def failure(conn, _activity, _reason) do
    conn
    |> put_status(401)
    |> json(%{
      authentication: %{
        status: :failed
      }
    })
  end

  # def sign_out(conn, _params) do
  #   conn
  #   |> revoke_bearer_tokens()
  #   |> json(%{
  #     status: :ok
  #   })
  # end
end
