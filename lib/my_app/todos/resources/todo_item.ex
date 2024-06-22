defmodule MyApp.Todos.TodoItem do
  use Ash.Resource,
    domain: MyApp.Todos,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "todo_items"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string do
      allow_nil? false
    end

    attribute :completed, :boolean do
      default false
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :todo_list, MyApp.Todos.TodoList do
      writable? true
      allow_nil? false
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      accept [:text]

      argument :todo_list_id, :uuid do
        allow_nil? false
      end

      change manage_relationship(:todo_list_id, :todo_list, type: :append)
    end

    update :update do
      accept [:text, :completed]
    end

    read :todos_by_todo_list do
      argument :todo_list_id, :uuid do
        allow_nil? false
      end

      filter expr(todo_list_id == ^arg(:todo_list_id))
    end
  end

  policies do
    policy action(:read) do
      authorize_if always()
    end

    policy action(:create) do
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if always()
    end

    policy action_type(:destroy) do
      authorize_if always()
    end
  end
end
