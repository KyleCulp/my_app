defmodule MyAppWeb.AuthLive.Index do
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

  defp apply_action(socket, :register, _params) do
    socket
    |> assign(:auth_action, "Register")
    |> assign(
      :form,
      Form.for_create(User, :register_with_password, api: MyApp.Accounts, as: "user") |> to_form()
    )
  end

  defp apply_action(socket, :login, _params) do
    socket
    |> assign(
      :form,
      Form.for_action(User, :sign_in_with_password, api: MyApp.Accounts, as: "user") |> to_form()
    )
  end

  defp action_text(:register), do: "Register"
  defp action_text(:login), do: "Log in"
  defp header_text(:register), do: "Create your Free Account"
  defp header_text(:login), do: "Log into your Account"
end
