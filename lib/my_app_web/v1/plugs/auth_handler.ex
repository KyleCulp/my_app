defmodule MyAppWeb.V1.Plugs.AuthHandler do
  @moduledoc false
  alias Plug.Conn
  alias MyApp.Session.{Store, AccessToken, RefreshToken}
  alias MyAppWeb.V1.Plugs.SessionHelper
  alias MyApp.Accounts.User
  alias Ash.Error.{Invalid, Unknown, Forbidden, Framework}

  @spec create_user(Conn.t(), map()) ::
          {:ok, Conn.t(), MyApp.Accounts.User.t()}
          | {:error, Conn.t(), Invalid.t() | Forbidden.t() | Unknown.t() | Framework.t()}
  def create_user(conn, user_params) do
    MyApp.Accounts.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:register, user_params)
    |> case do
      {:ok, user} -> {:ok, conn, user}
      {:error, error} -> {:error, conn, error}
    end
  end

  @doc """
  Authenticates an Ash Authentication User Resource
  """
  # @impl true
  # @spec authenticate_user(Conn.t(), map()) :: {Conn.t(), MyApp.Accounts.User.t() | nil}
  def authenticate_user(conn, user_params) do
    MyApp.Accounts.User
    |> AshAuthentication.Info.strategy!(:password)
    |> AshAuthentication.Strategy.action(:sign_in, user_params)
    |> case do
      {:ok, user} -> {:ok, conn, user}
      {:error, error} -> {:error, conn, error}
    end
  end

  @doc """
  Creates an access and refresh token for the user.

  The tokens are added to the `conn.private` as `:access_token` and
  `:refresh_token`. The refresh token is stored in the access token
  metadata and vice versa as session_id.
  """
  @spec create_session(Conn.t(), User.t()) :: {:atom, Conn.t(), User.t()}
  def create_session(conn, user) do
    # user = SessionHelper.get_actor(conn)
    # session_id = MyApp.UUID.generate()

    with session_id <- SessionHelper.find_or_create_session(conn, user),
         {:ok, access_token, access_token_expires_at} <-
           SessionHelper.create_token(session_id, user.id, :access),
         {:ok, refresh_token, refresh_token_expires_at} <-
           SessionHelper.create_token(session_id, user.id, :refresh),
         {:ok, _} <- Store.store_token(refresh_token),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- SessionHelper.encrypt(access_token.token),
         refresh_token <- SessionHelper.encrypt(refresh_token.token) do
      conn =
        conn
        |> Conn.put_private(:access_token, access_token)
        |> Conn.put_private(:refresh_token, refresh_token)
        |> Conn.put_private(:access_token_expires_at, access_token_expires_at)
        |> Conn.put_private(:refresh_token_expires_at, refresh_token_expires_at)

      {:ok, conn, user}
    else
      error -> IO.puts(error)
    end
  end

  @doc """
  Fetches the user from access token.
  """
  @impl true
  # @spec fetch(Conn.t()) :: {Conn.t(), map()}
  def fetch(conn) do
    with {:ok, signed_access_token, _} <- SessionHelper.fetch_tokens_from_cookies(conn),
         {:ok, access_token} <- SessionHelper.decrypt(signed_access_token),
         {:ok, token} <- Store.fetch_token(access_token, :access),
         {:ok, user} <- Ash.get(User, token["user_id"]) do
      conn |> Ash.PlugHelpers.set_actor(user)
    else
      # {:error, :not_found} -> SessionHelper.renew_access_token(conn)
      error -> IO.inspect(error)
    end
  end

  def authorized_by_cookies(conn) do
    with {:ok, req_cookies} <- Map.fetch(conn, :req_cookies),
         %{"access_token" => access_token} <- req_cookies,
         %{"refresh_token" => refresh_token} <- req_cookies do
      {access_token, refresh_token}
    else
      _ -> nil
    end
  end

  @doc """
  Delete the access token from the cache.

  The renewal token is deleted by fetching it from the access token metadata.
  """

  # @impl true
  # @spec delete(Conn.t(), Config.t()) :: Conn.t()
  # def delete(conn) do
  #   with {:ok, signed_token} <- SessionHelper.fetch_access_token(conn),
  #        {:ok, token} <- SessionHelper.decrypt(conn, signed_token),
  #        {_user, metadata} <- CredentialsCache.get(store_config, token) do
  #     Conn.register_before_send(conn, fn conn ->
  #       PersistentSessionCache.delete(store_config, metadata[:renewal_token])
  #       CredentialsCache.delete(store_config, token)

  #       conn
  #     end)
  #   else
  #     _any -> conn
  #   end
  # end

  @doc """
  Creates new tokens using the renewal token.

  The access token, if any, will be deleted by fetching it from the renewal
  token metadata. The renewal token will be deleted from the store after the
  it has been fetched.
  """

  # @spec renew(Conn.t(), Config.t()) :: {Conn.t(), map() | nil}
  def renew(conn) do
    with {:ok, refresh_token} <- SessionHelper.fetch_token_from_cookie(conn, "refresh_token"),
         {:ok, refresh_token} <- SessionHelper.decrypt(refresh_token),
         {:ok, refresh_token} <- Store.fetch_token(refresh_token, :refresh),
         {:ok, user} <- Ash.get(MyApp.Accounts.User, refresh_token["user_id"]) do
      create_session(conn, user)
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  def renew(conn, refresh_token) do
    with {:ok, refresh_token} <- SessionHelper.decrypt(refresh_token),
         {:ok, refresh_token} <- Store.fetch_token(refresh_token, :refresh),
         {:ok, user} <- Ash.get(MyApp.Accounts.User, refresh_token["user_id"]),
         session_id <- SessionHelper.find_or_create_session(conn, user),
         {:ok, access_token, access_token_expires_at} <-
           SessionHelper.create_token(session_id, user.id, :access),
         {:ok, refresh_token, _} <- SessionHelper.create_token(session_id, user.id, :refresh),
         {:ok, _} <- Store.store_token(refresh_token),
         {:ok, _} <- Store.store_token(access_token),
         access_token <- SessionHelper.encrypt(access_token.token),
         refresh_token <- SessionHelper.encrypt(refresh_token.token) do
      conn
      |> SessionHelper.apply_token_cookie("access_token", conn.private.access_token)
      |> SessionHelper.apply_token_cookie("refresh_token", conn.private.refresh_token)
    else
      err ->
        IO.inspect(err)
        conn
    end
  end

  defp fetch_secrets do
    with secret_key_base <- Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:secret_key_base],
         access_salt <- Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:access_salt],
         refresh_salt <- Application.fetch_env!(:my_app, MyAppWeb.Endpoint)[:refresh_salt] do
      {secret_key_base, access_salt, refresh_salt}
    end
  end
end
