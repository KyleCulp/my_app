defmodule MyAppWeb.Plugs.GetActorFromToken do
  import Plug.Conn

  def get_actor_from_token(conn, _opts) do
    with ["" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user, _claims} <- MyApp.Guardian.resource_from_token(token) do
      conn
      |> Ash.PlugHelpers.set_actor(user)
    else
      _ -> conn
    end
  end
end
