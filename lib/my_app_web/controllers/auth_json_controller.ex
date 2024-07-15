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

  def failure(conn, _activity, reason) do
    conn
    |> put_status(401)
    |> json(%{
      authentication: %{
        status: :failed,
        errors: grab_reason_errors(reason)
      }
    })
  end

  def grab_reason_errors(reason) do
    reason
    |> Map.get(:caused_by)
    |> Map.get(:errors)
    |> Enum.map(fn error ->
      error
      |> Map.get(:caused_by)
      |> Map.get(:message)
    end)
  end

  def sign_out(conn, _params) do
    conn
    |> revoke_bearer_tokens(:my_app)
    # |> AshAuthentication.Plug.Helpers.revoke_bearer_tokens(:my_app)
    |> json(%{
      status: :ok
    })
  end

  def revoke_token(conn, otp_app) do
    conn
    |> Conn.get_req_header("authorization")
    |> Stream.filter(&String.starts_with?(&1, "Bearer "))
    |> Stream.map(&String.replace_leading(&1, "Bearer ", ""))
    |> Enum.reduce(conn, fn token, conn ->
      with {:ok, resource} <- Jwt.token_to_resource(token, otp_app),
           {:ok, token_resource} <- Info.authentication_tokens_token_resource(resource),
           :ok <- TokenResource.Actions.revoke(token_resource, token) do
        conn
      else
        _ -> conn
      end
    end)
  end
end
