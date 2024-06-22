defmodule MyApp.Todos do
  use Ash.Domain, extensions: [AshJsonApi.Domain], otp_app: :my_app

  resources do
    resource MyApp.Todos.TodoList do
      define :by_id, action: :by_id, args: [:id]
    end

    resource MyApp.Todos.TodoItem do
      define :add_todo, action: :create, args: [:todo_list_id]
    end
  end
end
