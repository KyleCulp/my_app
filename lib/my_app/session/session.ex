defmodule MyApp.Session do
  alias MyApp.Session.Store
  alias Plug.Conn

  # @table
  def authenticate_user(conn, user_params) do
    MyApp.Accounts.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:sign_in, user_params)
    |> maybe_create_session(conn)
  end

  defp maybe_create_session({:error, changeset}, conn), do: {:error, changeset, conn}

  defp maybe_create_session({:ok, user}, conn), do: create_session(conn, user)

  def create_session(conn, user) do
    refresh_token = create_token(conn, :refresh, user.id)
    access_token = create_token(conn, :access, user.id)

    with {:ok, _} <- Store.store_refresh_token(refresh_token),
         {:ok, _} <- Store.store_access_token(access_token) do
      conn =
        conn
        |> Conn.put_private(:access_token, access_token.token)
        |> Conn.put_private(:refresh_token, refresh_token.token)

      {:ok, user, conn}
    end

    # {:ok, user, conn}
    # {:ok, conn, user}
  end

  # def is_token_expired?(token) do
  #   IO.inspect(token)
  #   false
  # end

  def renew_token(conn, type, user_id) do
  end

  defp create_token(conn, type, user_id) do
    MyApp.Session.Token.new(type, %{
      user_id: user_id,
      user_agent: get_user_agent(conn),
      ip_address: get_ip_address(conn)
    })
  end

  defp get_user_agent(conn) do
    case Plug.Conn.get_req_header(conn, "user-agent") do
      [user_agent | _] -> user_agent
      [user_agent] -> user_agent
      [] -> nil
    end
  end

  defp get_ip_address(conn) do
    case Plug.Conn.get_req_header(conn, "x-forwarded-for") do
      [forwarded_for | _] ->
        # The "x-forwarded-for" header can contain multiple IPs, we take the first one
        String.split(forwarded_for, ",")
        |> List.first()
        |> String.trim()

      [] ->
        case Plug.Conn.get_req_header(conn, "x-real-ip") do
          [real_ip | _] -> real_ip
          [] -> format_ip(conn.remote_ip)
        end
    end
  end

  defp format_ip({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
  defp format_ip(_), do: nil

  def apply_cookies(conn) do
    conn
    |> Plug.Conn.put_resp_cookie("access_token", conn.private.access_token,
      http_only: true,
      same_site: "Strict",
      sign: true
    )
    |> Plug.Conn.put_resp_cookie("refresh_token", conn.private.refresh_token,
      http_only: true,
      same_site: "Strict",
      domain: "localhost",
      sign: true
    )
  end

  # defp generate_token(user_id) do
  #   datetime = :calendar.universal_time() |> :calendar.datetime_to_gregorian_seconds()

  #   %{
  #     token: :crypto.strong_rand_bytes(32) |> Base.encode64(),
  #     user_id: user_id,
  #     inserted_at: datetime,
  #     expires_at: datetime
  #   }
  # end

  # # defp generate_access_token(token, user_id) do
  #   %{
  #     token: token,
  #     expires_at:
  #       :calendar.universal_time() |> (:calendar.datetime_to_gregorian_seconds() + 7200),
  #     inserted_at: :calendar.universal_time(),
  #     updated_at: :calendar.universal_time()
  #   }
  # end
end
