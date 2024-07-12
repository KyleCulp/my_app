defmodule MyApp.Todos do
  use Ash.Domain, extensions: [AshJsonApi.Domain, AshGraphql.Domain], otp_app: :my_app
  alias MyApp.Todos.{TodoList, TodoItem}

  resources do
    resource TodoList do
      define :by_id, action: :by_id, args: [:id]
    end

    resource TodoItem do
      define :add_todo, action: :create, args: [:todo_list_id]
    end
  end

  json_api do
    routes do
      base_route "/api/todos/todo_list", TodoList do
        # in the domain `base_route` acts like a scope
        index :read
        get(:read)
        post(:create)
        patch(:update)
        # post(:register_with_password, route: "/register")
        # post(:sign_in_with_password, route: "/login")
      end

      base_route "/api/todos/todo_item", TodoItem do
        index :read
        get(:read)
        post(:create, relationship_arguments: [:todo_list])
        patch(:update)
      end
    end
  end

  graphql do
    authorize? false
    show_raised_errors?(true)
    root_level_errors?(true)

    queries do
      list TodoList, :list_todo_lists, :read
      get TodoList, :get_todo_list, :read
      list(TodoList, :users_lists, :users_lists)
    end

    mutations do
      create(TodoList, :create_todo_list, :create)
    end
  end
end
