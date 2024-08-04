defmodule MyAppWeb.V1.Plugs.Session do
  @moduledoc false
  alias MyAppWeb.V1.Plugs.{SessionHelper, AuthHandler}
  alias Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    with ["" <> token] <- Conn.get_req_header(conn, "authorization") do
      # conn |> Ash.PlugHelpers.set_actor(user)
      IO.inspect(token)
      conn
    else
      _ ->
        conn
    end
  end

  def extract_user_id(jwt) do
    case jwt["sub"] do
      "user?id=" <> user_id -> user_id
      _ -> :error
    end
  end

  def verify_token(token) do
    case AshAuthentication.Jwt.verify(token, :my_app) do
      {:ok, jwt, _user_module} -> jwt
      _ -> :error
    end
  end

  # def get_user(token) do
  #   user_id =
  #     token
  #     |> verify_token()
  #     |> extract_user_id()

  #   MyApp.Accounts.User |> Ash.get(user_id)
  # end

  # defp check_auth_header(conn) do
  #   if !SessionHelper.has_valid_actor?(conn) do
  #     case Conn.get_req_header(conn, "authorization") do
  #       [] -> conn
  #       ["Bearer " <> token] -> authorize_with_header(conn, token)
  #       _ -> conn
  #     end
  #   else
  #     conn
  #   end
  # end

  # defp check_auth_cookie(conn) do
  #   conn
  #   |> Map.fetch!(:req_cookies)
  #   |> case do
  #     %{"access_token" => token} ->
  #       SessionHelper.authenticate_via_token(conn, token)

  #     %{"refresh_token" => token} ->
  #       # stupid piping making accessing conn private a hastle
  #       conn = conn |> SessionHelper.renew_access_token(token)
  #       SessionHelper.authenticate_via_token(conn, conn.private.access_token)

  #     _ ->
  #       conn
  #   end
  # end
end
