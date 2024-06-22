defmodule MyAppWeb.TodoListLive.Index do
  use MyAppWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Listing Todo lists
      <:actions>
        <.link patch={~p"/todo_lists/new"}>
          <.button>New Todo list</.button>
        </.link>
      </:actions>
    </.header>

    <.table
      id="todo_lists"
      rows={@streams.todo_lists}
      row_click={fn {_id, todo_list} -> JS.navigate(~p"/todo_lists/#{todo_list}") end}
    >
      <:col :let={{_id, todo_list}} label="Id"><%= todo_list.id %></:col>

      <:action :let={{_id, todo_list}}>
        <div class="sr-only">
          <.link navigate={~p"/todo_lists/#{todo_list}"}>Show</.link>
        </div>

        <.link patch={~p"/todo_lists/#{todo_list}/edit"}>Edit</.link>
      </:action>

      <:action :let={{id, todo_list}}>
        <.link
          phx-click={JS.push("delete", value: %{id: todo_list.id}) |> hide("##{id}")}
          data-confirm="Are you sure?"
        >
          Delete
        </.link>
      </:action>
    </.table>

    <.modal
      :if={@live_action in [:new, :edit]}
      id="todo_list-modal"
      show
      on_cancel={JS.patch(~p"/todo_lists")}
    >
      <.live_component
        module={MyAppWeb.TodoListLive.FormComponent}
        id={(@todo_list && @todo_list.id) || :new}
        title={@page_title}
        current_user={@current_user}
        action={@live_action}
        todo_list={@todo_list}
        patch={~p"/todo_lists"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    IO.inspect(socket.assigns.current_user)

    {:ok,
     socket
     |> stream(:todo_lists, Ash.read!(MyApp.Todos.TodoList, actor: socket.assigns[:current_user]))
     |> assign_new(:current_user, fn -> nil end)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo list")
    |> assign(:todo_list, Ash.get!(MyApp.Todos.TodoList, id, actor: socket.assigns.current_user))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo list")
    |> assign(:todo_list, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todo lists")
    |> assign(:todo_list, nil)
  end

  @impl true
  def handle_info({MyAppWeb.TodoListLive.FormComponent, {:saved, todo_list}}, socket) do
    {:noreply, stream_insert(socket, :todo_lists, todo_list)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo_list = Ash.get!(MyApp.Todos.TodoList, id, actor: socket.assigns.current_user)
    Ash.destroy!(todo_list, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :todo_lists, todo_list)}
  end
end
