defmodule MyAppWeb.AuthLive.AuthForm do
  use MyAppWeb, :live_component
  alias AshPhoenix.Form

  @impl true
  def update(assigns, socket) do
    socket =
      socket
      |> assign(assigns)

    {:ok, socket}
  end

  @impl true
  def handle_event("validate", %{"user" => params}, socket) do
    form = socket.assigns.form |> Form.validate(params, errors: false)

    {:noreply, assign(socket, form: form)}
  end

  @impl true
  def handle_event("submit", %{"user" => params}, socket) do
    case Form.submit(socket.assigns.form,
           params: params,
           read_one?: true,
           before_submit: &Ash.Changeset.set_context(&1, %{token_type: :sign_in})
         ) do
      {:ok, user} ->
        {:noreply,
         redirect(socket,
           to: ~p"/auth/user/password/sign_in_with_token?token=#{user.__metadata__.token}"
         )}

      {:error, form} ->
        {:noreply,
         assign(socket, :form, Form.clear_value(form, [:password, :password_confirmation]))}
    end
  end

  defp button_text(:register), do: "Register"
  defp button_text(:login), do: "Log in"
  defp button_loading_text(:register), do: "Registering Account..."
  defp button_loading_text(:login), do: "Logging in..."
end
