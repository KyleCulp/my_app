defmodule MyApp.Session.Store do
  use GenServer

  alias MyApp.Session.{Token, Session, AccessToken, RefreshToken}
  alias MyApp.Redis

  @refresh_token "refresh"
  @access_token "access"

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(_) do
    Redis.start_link(:ok)
    {:ok, %{}}
  end

  def store_token(%Token{} = token) do
    key = "#{token.type}:#{token.token}"
    value = Map.from_struct(token) |> Jason.encode!()

    Redis.command(["SET", key, value])
    Redis.command(["EXPIRE", key, token.expires_at - :os.system_time(:seconds)])
  end

  # def delete_token(%Token{} = token)

  @spec fetch_token(String.t(), :access | :refresh) ::
          {:ok, Token.t()} | {:error, :not_found | any()}
  def fetch_token(token, type) do
    case Redis.command(["GET", "#{type}:#{token}"]) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, json} -> {:ok, Jason.decode!(json)}
      {:error, reason} -> {:error, reason}
    end
  end

  def fetch_access_token(token) do
    key = "#{@access_token}:#{token}"

    case Redis.command(["GET", key]) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, json} -> {:ok, Jason.decode!(json)}
      {:error, reason} -> {:error, reason}
    end
  end

  def fetch_refresh_token(token) do
    key = "#{@refresh_token}:#{token}"

    case Redis.command(["GET", key]) do
      {:ok, nil} -> {:error, :not_found}
      {:ok, json} -> {:ok, Jason.decode!(json)}
      {:error, reason} -> {:error, reason}
    end
  end

  def delete_access_token(token) when is_map(token), do: delete_access_token(token.token)

  def delete_access_token(token) do
    key = "#{@access_token}:#{token}"

    Redis.command(["DEL", key])
  end

  def delete_refresh_token(token) when is_map(token), do: delete_refresh_token(token.token)

  def delete_refresh_token(token) do
    key = "#{@refresh_token}:#{token}"

    Redis.command(["DEL", key])
  end
end
