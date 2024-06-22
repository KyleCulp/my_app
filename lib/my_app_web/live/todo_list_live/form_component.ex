defmodule MyAppWeb.TodoListLive.FormComponent do
  use MyAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage todo_list records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="todo_list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:title]} type="text" label="Title" /><.input
          field={@form[:description]}
          type="text"
          label="Description"
        />

        <:actions>
          <.button phx-disable-with="Saving...">Save Todo list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"todo_list" => todo_list_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, todo_list_params))}
  end

  def handle_event("save", %{"todo_list" => todo_list_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: todo_list_params) do
      {:ok, todo_list} ->
        notify_parent({:saved, todo_list})

        socket =
          socket
          |> put_flash(:info, "Todo list #{socket.assigns.form.source.type}d successfully")
          |> push_patch(to: socket.assigns.patch)

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{todo_list: todo_list}} = socket) do
    form =
      if todo_list do
        AshPhoenix.Form.for_update(todo_list, :update,
          as: "todo_list",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(MyApp.Todos.TodoList, :create,
          as: "todo_list",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end
end
