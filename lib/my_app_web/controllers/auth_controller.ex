defmodule MyAppWeb.AuthController do
  use MyAppWeb, :controller
  use AshAuthentication.Phoenix.Controller
  alias AshAuthentication.TokenResource

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

  def failure(conn, _activity, reason) do
    IO.inspect(reason)

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

  # def success(conn, _activity, user, _token) do
  #   return_to = get_session(conn, :return_to) || ~p"/"

  #   conn
  #   |> delete_session(:return_to)
  #   |> store_in_session(user)
  #   |> assign(:current_user, user)
  #   |> redirect(to: return_to)
  # end

  # def failure(conn, activity, reason) do
  #   IO.inspect(activity)
  #   IO.inspect(reason)

  #   conn
  #   |> put_flash(:error, "Incorrect email or password")
  #   |> redirect(to: ~p"/login")
  # end

  # def sign_out(conn, _params) do
  #   return_to = get_session(conn, :return_to) || ~p"/"

  #   conn
  #   |> clear_session()
  #   |> redirect(to: return_to)
  # end

  # def action(conn, params) do
  #   args = [conn, conn.params, params]
  #   apply(__MODULE__, action_name(conn), args)
  # end

  # def user_google_request(conn, _params) do
  #   # Handle the Google request logic here
  #   # Example:
  #   conn
  #   |> put_flash(:info, "Google request initiated")
  #   |> redirect(to: "/")
  # end

  # def user_google_callback(conn, _params) do
  #   # Handle the Google callback logic here
  #   # Example:
  #   conn
  #   |> put_flash(:info, "Google callback received")
  #   |> redirect(to: "/")
  # end
end

defmodule MyAppWeb.AuthHTML do
  use MyAppWeb, :html

  embed_templates "auth_html/*"
end
