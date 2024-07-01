defmodule MyAppWeb.ProfileLive.Index do
  use MyAppWeb, :live_view

  alias MyApp.Accounts.User
  alias AshPhoenix.Form

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  defp apply_action(socket, :login, _params) do
    socket
  end
end
