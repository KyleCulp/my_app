# defmodule MyApp.Session.Store do
#   # use Guardian, otp_app: :my_app
#   use GenServer

#   alias MyApp.Session.Token
#   alias :mnesia, as: Mnesia

#   @access_tokens_table :access_tokens
#   @refresh_tokens_table :refresh_tokens

#   def start_link(_opts) do
#     GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
#   end

#   def init(_) do
#     setup_mnesia()
#     create_tables()
#     IO.inspect("hello")

#     {:ok, %{}}
#   end

#   def store_refresh_token(%Token{
#         token: token,
#         session_id: session_id,
#         user_id: user_id,
#         inserted_at: inserted_at,
#         expires_at: expires_at,
#         last_active: last_active,
#         ip_address: ip_address,
#         user_agent: user_agent,
#         login_method: login_method
#       }) do
#     :mnesia.transaction(fn ->
#       :mnesia.write(
#         {@refresh_tokens_table, token, session_id, user_id, inserted_at, expires_at, last_active,
#          ip_address, user_agent, login_method}
#       )
#     end)
#   end

#   def store_access_token(%Token{
#         token: token,
#         session_id: session_id,
#         user_id: user_id,
#         inserted_at: inserted_at,
#         expires_at: expires_at
#       }) do
#     :mnesia.transaction(fn ->
#       :mnesia.write({@access_tokens_table, token, session_id, user_id, inserted_at, expires_at})
#     end)
#   end

#   def fetch_access_token(token) do
#     :mnesia.transaction(fn ->
#       case :mnesia.read({@access_tokens_table, token}) do
#         [] -> {:error, :not_found}
#         [record] -> {:ok, record}
#       end
#     end)
#   end

#   def fetch_refresh_token(token) do
#     :mnesia.transaction(fn ->
#       case :mnesia.read({@refresh_tokens_table, token}) do
#         [] -> {:error, :not_found}
#         [record] -> {:ok, record}
#       end
#     end)
#   end

#   def delete_access_token(token) do
#     :mnesia.transaction(fn ->
#       :mnesia.delete({@access_tokens_table, token})
#     end)
#   end

#   def delete_refresh_token(token) do
#     :mnesia.transaction(fn ->
#       :mnesia.delete({@refresh_tokens_table, token})
#     end)
#   end

#   defp setup_mnesia do
#     File.mkdir_p!("priv/mnesia/#{Mix.env()}/")

#     case Mnesia.create_schema([node()]) do
#       :ok -> :ok
#       {:error, {:already_exists, _}} -> :ok
#       error -> error
#     end

#     case Mnesia.start() do
#       :ok -> :ok
#       error -> error
#     end
#   end

#   defp create_tables() do
#     with :ok <- create_access_tokens_table(),
#          :ok <- create_refresh_tokens_table() do
#       :ok
#     else
#       {:aborted, reason} -> {:error, reason}
#     end
#   end

#   defp create_access_tokens_table() do
#     case Mnesia.create_table(:access_tokens,
#            attributes: [
#              :token,
#              :session_id,
#              :user_id,
#              :inserted_at,
#              :expires_at
#            ],
#            disc_copies: [node()],
#            type: :set
#          ) do
#       {:atomic, :ok} -> :ok
#       {:aborted, {:already_exists, _}} -> :ok
#       {:aborted, reason} -> {:error, reason}
#     end
#   end

#   defp create_refresh_tokens_table() do
#     case Mnesia.create_table(:refresh_tokens,
#            attributes: [
#              :token,
#              :session_id,
#              :user_id,
#              :inserted_at,
#              :expires_at,
#              :last_active,
#              :ip_address,
#              :user_agent,
#              :login_method
#            ],
#            disc_copies: [node()],
#            type: :set
#          ) do
#       {:atomic, :ok} -> :ok
#       {:aborted, {:already_exists, _}} -> :ok
#       {:aborted, reason} -> {:error, reason}
#     end
#   end
# end
