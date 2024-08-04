defmodule MyAppWeb.V1.Plugs.SessionHelper do
  alias MyAppWeb.Plugs.AuthHandler
  alias Plug.Conn
  alias MyApp.Session.Store
  alias MyApp.Accounts.User

  def create_session(conn, user) do
    with session_id <- find_or_create_session(conn, user),
         {:ok, access_token, access_token_expires_at} <-
           create_token(session_id, user.id, :access),
         {:ok, refresh_token, _} <- create_token(session_id, user.id, :refresh),
         {:ok, _} <- Store.store_token(refresh_token),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- encrypt(access_token.token),
         refresh_token <- encrypt(refresh_token.token) do
      conn =
        conn
        |> Conn.put_private(:access_token, access_token)
        |> Conn.put_private(:refresh_token, refresh_token)
        |> Conn.put_private(:access_token_expires_at, access_token_expires_at)

      {:ok, conn, user}
    else
      error -> IO.puts(error)
    end
  end

  def authenticate_via_token(conn, signed_token) do
    with {:ok, access_token} <- decrypt(signed_token),
         {:ok, token} <- Store.fetch_token(access_token, :access),
         {:ok, user} <- Ash.get(User, token["user_id"]) do
      IO.inspect(user)
      conn |> Ash.PlugHelpers.set_actor(user)
    else
      # {:error, :not_found} -> SessionHelper.renew_access_token(conn)
      error -> IO.inspect(error)
    end
  end

  def renew_access_token(conn) do
    with {:ok, refresh_token} <- fetch_token_from_cookie(conn, "refresh_token"),
         do: renew_access_token(conn, refresh_token)
  end

  def renew_access_token(conn, refresh_token) do
    with {:ok, refresh_token} <- decrypt(refresh_token),
         {:ok, refresh_token} <- Store.fetch_token(refresh_token, :refresh),
         {:ok, user} <- Ash.get(MyApp.Accounts.User, refresh_token["user_id"]),
         {:ok, access_token, access_token_expires_at} <-
           create_token(refresh_token["session_id"], user.id, :access),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- encrypt(access_token.token) do
      conn
      |> Conn.put_private(:access_token, access_token)
      |> Conn.put_private(:refresh_token, refresh_token)
      |> Conn.put_private(:access_token_expires_at, access_token_expires_at)

      # AuthHandler.create_session(conn, user)
    else
      error -> IO.inspect(error)
    end
  end

  def renew(conn, refresh_token) do
    with {:ok, refresh_token} <- decrypt(refresh_token),
         {:ok, refresh_token} <- Store.fetch_token(refresh_token, :refresh),
         {:ok, access_token, access_token_expires_at} <-
           create_token(refresh_token["session_id"], refresh_token["user_id"], :access),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- encrypt(access_token.token) do
      conn =
        conn
        |> Conn.put_private(:access_token, access_token)
        |> Conn.put_private(:access_token_expires_at, access_token_expires_at)

      {:ok, conn}
    else
      # TODO
      {:error, :expired} -> {:error, :expired, conn}
      err -> IO.inspect(err)
    end
  end

  def get_actor(conn) do
    with {:ok, private} <- Map.fetch(conn, :private),
         {:ok, ash} <- Map.fetch(private, :ash),
         {:ok, actor} <- Map.fetch(ash, :actor) do
      {:ok, actor}
    else
      {:error, error} -> {:error, error}
    end
  end

  def has_valid_actor?(conn) do
    case get_actor(conn) do
      {:ok, _} -> true
      _ -> false
    end
  end

  def find_or_create_session(conn, user), do: MyApp.UUID.generate()

  @spec fetch_tokens_from_cookies(Conn.t()) ::
          {:ok, {String.t(), String.t()}}
          | {:error, :access_token_not_found | :refresh_token_not_found}
  def fetch_tokens_from_cookies(conn) do
    with {:ok, access_token} <- fetch_token_from_cookie(conn, "access_token"),
         {:ok, refresh_token} <- fetch_token_from_cookie(conn, "refresh_token") do
      {:ok, access_token, refresh_token}
    else
      {:error, :access_token} -> {:error, :access_token_not_found}
      {:error, :refresh_token} -> {:error, :refresh_token_not_found}
    end
  end

  def fetch_token_from_cookie(conn, key) do
    case Map.fetch(conn.req_cookies, key) do
      {:ok, token} -> {:ok, token}
      :error -> {:error, key}
    end
  end

  @spec fetch_access_token_from_header(Conn.t()) :: {:ok, String.t()} | :error
  def fetch_access_token_from_header(conn) do
    case Conn.get_req_header(conn, "authorization") do
      [token | _rest] -> {:ok, token}
      _any -> :error
    end
  end

  def create_token(session_id, user_id, type) do
    token =
      MyApp.Session.Token.new(%{
        session_id: session_id,
        user_id: user_id,
        type: type
      })

    {:ok, token, token.expires_at}
  end

  def apply_token_cookie(conn, name, token) when is_atom(name),
    do: apply_token_cookie(conn, Atom.to_string(name), token)

  # Do not sign or encrypt the cookie. The tokens are already encrypted,
  # as they are also returned via json response and therefore need to be encrypted prior
  def apply_token_cookie(conn, name, token) do
    conn
    |> Conn.put_resp_cookie(name, token,
      http_only: true,
      same_site: "Strict",
      domain: "localhost",
      sign: false,
      max_age: max_age(name)
    )
  end

  defp max_age("access_token"), do: 900
  defp max_age("refresh_token"), do: 2_419_200
  defp max_age(_), do: 900

  def renew_access_token(conn) do
    with {:ok, refresh_token} <- fetch_token_from_cookie(conn, "refresh_token"),
         {:ok, refresh_token} <- decrypt(refresh_token),
         {:ok, refresh_token} <- Store.fetch_token(refresh_token, :refresh),
         {:ok, user} <- Ash.get(MyApp.Accounts.User, refresh_token.user_id),
         {:ok, access_token, _} <- create_token(refresh_token["session_id"], user.id, :access),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- encrypt(access_token.token) do
      conn =
        conn
        |> Conn.put_private(:access_token, access_token)
        |> Conn.put_resp_cookie("access_token", access_token)
    else
      error -> IO.inspect(error)
    end
  end

  defp get_user_agent(conn) do
    case Plug.Conn.get_req_header(conn, "user-agent") do
      [user_agent | _] -> user_agent
      [user_agent] -> user_agent
      [] -> nil
    end
  end

  defp get_ip_address(conn) do
    case Conn.get_req_header(conn, "x-forwarded-for") do
      [forwarded_for | _] ->
        # The "x-forwarded-for" header can contain multiple IPs, we take the first one
        String.split(forwarded_for, ",")
        |> List.first()
        |> String.trim()

      [] ->
        case Conn.get_req_header(conn, "x-real-ip") do
          [real_ip | _] -> real_ip
          [] -> format_ip(conn.remote_ip)
        end
    end
  end

  defp format_ip({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
  defp format_ip(_), do: nil

  defp signing_salt(), do: Atom.to_string(__MODULE__)

  def encrypt(data) when is_map(data), do: encrypt(data.token)

  @spec encrypt(String.t()) :: {:ok, String.t()} | {:error, :expired} | :invalid | :missing
  def encrypt(data) do
    Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:secret_key_base]
    |> Phoenix.Token.encrypt(signing_salt(), data)
  end

  @spec decrypt(String.t()) :: {:ok, String.t()} | {:error, :expired} | :invalid | :missing
  def decrypt(data) do
    Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:secret_key_base]
    |> Phoenix.Token.decrypt(signing_salt(), data)
  end
end
