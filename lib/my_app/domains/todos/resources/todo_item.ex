defmodule MyApp.Todos.TodoItem do
  use Ash.Resource,
    domain: MyApp.Todos,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource, AshGraphql.Resource],
    notifiers: [Ash.Notifier.PubSub]

  postgres do
    table "todo_items"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :text, :string do
      allow_nil? false
      public? true
    end

    attribute :completed, :boolean do
      default false
      public? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :todo_list, MyApp.Todos.TodoList do
      writable? true
      allow_nil? false
      public? true
    end
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      accept [:text]

      argument :todo_list, :map do
        allow_nil? false
      end

      change manage_relationship(:todo_list, type: :append)
    end

    # create :create_direct do
    #   argument :todo_list, :map, allow_nil?: false
    #   accept [:text]
    #   change manage_relationship(:todo_list, type: :append)
    # end

    update :update do
      primary? true
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

  json_api do
    type "todo_item"
  end

  graphql do
    type :todo_item
  end
end
