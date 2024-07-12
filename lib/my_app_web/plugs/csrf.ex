defmodule MyAppWeb.Plugs.CsrfTokenHeader do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    csrf_token = Plug.CSRFProtection.get_csrf_token()

    conn
    |> put_resp_header("x-csrf-token", csrf_token)
  end
end
