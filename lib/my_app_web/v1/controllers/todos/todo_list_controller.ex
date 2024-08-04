defmodule MyAppWeb.V1.TodoListController do
  use MyAppWeb, :controller

  require Ash.Query
  alias MyAppWeb.Plugs.AuthHandler
  alias MyAppWeb.V1.Plugs.SessionHelper
  alias MyApp.Todos
  alias MyApp.Todos.TodoList
  alias MyAppWeb.V1.QueryParams
  alias Ash.Query

  action_fallback MyAppWeb.FallbackController

  defp list_items(resource, action, %QueryParams{} = query_params, actor \\ nil) do
    # IO.inspect(query_params)

    resource
    # |> Query.load(action)
    # |> Query.page(query_params.page)
    # |> Query.limit(query_params.limit)
    # |> Query.sort(sort)
    # |> Query.filter(query_params.filters)
    |> Ash.read!(actor: actor)
    |> IO.inspect()
  end

  def index(conn, params) do
    {:ok, params} = QueryParams.new(params)

    {:ok, user} =
      conn
      |> AuthHandler.fetch()
      |> SessionHelper.get_actor()

    list_items(TodoList, :todo_items, params, user)

    # TodoList |> Query
    conn |> json(%{xd: "xd"})
    # case QueryParams.new(params) do
    #   {:ok, validated_params} ->
    #     # todo_lists = list_items(TodoList, :todo_items, validated_params)
    #     render(conn, :index, todo_lists: %{xd: "xd"})

    #   {:error, error_msg} ->
    #     conn
    #     |> put_status(:bad_request)
    #     |> json(%{error: error_msg})
    # end

    # todo_lists = TodoList |> Ash.Query.load(:todo_items) |> Ash.read!()
    # IO.inspect(params)

    # render(conn, :index, todo_lists: todo_lists)
  end

  def create(conn, %{"todo_list" => todo_list_params}) do
    with {:ok, %TodoList{} = todo_list} <- Todos.create_todo_list(todo_list_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/todo_lists/#{todo_list}")
      |> render(:show, todo_list: todo_list)
    end
  end

  def show(conn, %{"id" => id}) do
    todo_list = Todos.get_todo_list!(id)
    render(conn, :show, todo_list: todo_list)
  end

  def update(conn, %{"id" => id, "todo_list" => todo_list_params}) do
    todo_list = Todos.get_todo_list!(id)

    with {:ok, %TodoList{} = todo_list} <- Todos.update_todo_list(todo_list, todo_list_params) do
      render(conn, :show, todo_list: todo_list)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo_list = Todos.get_todo_list!(id)

    with {:ok, %TodoList{}} <- Todos.delete_todo_list(todo_list) do
      send_resp(conn, :no_content, "")
    end
  end
end
