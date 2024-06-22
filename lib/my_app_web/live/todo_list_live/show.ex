defmodule MyAppWeb.TodoListLive.Show do
  require Ash.Query
  use MyAppWeb, :live_view
  alias MyApp.Todos.{TodoList, TodoItem}

  @impl true
  def render(assigns) do
    ~H"""
    <.header>
      Todo list <%= @todo_list.id %>
      <:subtitle>This is a todo_list record from your database.</:subtitle>

      <:actions>
        <.link patch={~p"/todo_lists/#{@todo_list}/show/edit"} phx-click={JS.push_focus()}>
          <.button>Edit todo_list</.button>
        </.link>
      </:actions>
    </.header>

    <.list>
      <:item title="Id"><%= @todo_list.id %></:item>
    </.list>
    <%= for todo <- @todo_list.todo_items do %>
      <%= todo.text %>
    <% end %>

    <.back navigate={~p"/todo_lists"}>Back to todo_lists</.back>

    <.modal
      :if={@live_action == :edit}
      id="todo_list-modal"
      show
      on_cancel={JS.patch(~p"/todo_lists/#{@todo_list}")}
    >
      <.live_component
        module={MyAppWeb.TodoListLive.FormComponent}
        id={@todo_list.id}
        title={@page_title}
        action={@live_action}
        current_user={@current_user}
        todo_list={@todo_list}
        patch={~p"/todo_lists/#{@todo_list}"}
      />
    </.modal>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo_list, get_todo_list_items(id, socket.assigns.current_user))}
  end

  defp get_todo_list_items(id, current_user) do
    # TodoList
    # TodoList
    # |> Ash.Query.load(:todo_items)
    # |> Ash.get!(id)
    #   |> Ash.Query.filter(id == ^id)
    #   |> Ash.Query.act
    TodoList
    |> Ash.Query.load(:todo_items)
    |> Ash.read_first!()

    #   |> Ash.Query.sort(created_at: :asc)

    # TodoList.
    # Ash.get!(MyApp.Todos.TodoList, id, actor: current_user)
    # |> IO.inspect()
  end

  defp page_title(:show), do: "Show Todo list"
  defp page_title(:edit), do: "Edit Todo list"
end
