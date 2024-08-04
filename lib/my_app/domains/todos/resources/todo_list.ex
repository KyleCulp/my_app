defmodule MyApp.Todos.TodoList do
  use Ash.Resource,
    domain: MyApp.Todos,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    extensions: [AshJsonApi.Resource, AshGraphql.Resource],
    notifiers: [Ash.Notifier.PubSub]

  postgres do
    table "todo_lists"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      public? true
      constraints max_length: 64, min_length: 1, trim?: true
    end

    attribute :description, :string do
      allow_nil? true
      public? true
    end

    create_timestamp :created_at, public?: true
    update_timestamp :updated_at, public?: true
  end

  relationships do
    belongs_to :user, MyApp.Accounts.User do
      writable? true
      allow_nil? false
      public? true
    end

    has_many :todo_items, MyApp.Todos.TodoItem, public?: true
  end

  actions do
    defaults [:read, :destroy]

    read :get do
      primary? true
      get? true
      argument :id, :uuid
      filter expr(id == ^arg(:id))
      # prepare build(load: [:todo_items, :user])
      prepare fn query, _ ->
        query
        |> Ash.Query.load(:todo_items)
        |> Ash.Query.load(:user)
        |> IO.inspect()
      end
    end

    read :users_lists do
      argument :user_id, :uuid
      filter expr(user_id == ^arg(:user_id))
    end

    create :create do
      primary? true
      accept [:title, :description]
      argument :todo_items, {:array, :map}
      upsert? true

      change relate_actor(:user)
      # change manage_relationship(:todo_items, type: :create)
    end

    update :update do
      primary? true
      argument :todo_items, :map, allow_nil?: true
      accept [:title, :description]
      change relate_actor(:user)
      # change manage_relationship(:todo_items, type: :update)
    end

    read :by_id do
      argument :id, :uuid, allow_nil?: false
      # Tells us we expect this action to return a single result
      get? true
      filter expr(id == ^arg(:id))
    end
  end

  policies do
    # policy action_type(:read) do
    #   authorize_if(relates_to_actor_via(:user))
    # end

    policy action(:read) do
      authorize_if(always())
    end

    # policy action(:read) do
    #   authorize_if(relates_to_actor_via(:user))
    # end

    policy action(:get) do
      authorize_if(relates_to_actor_via(:user))
    end

    policy action(:create) do
      authorize_if always()
    end

    policy action_type(:update) do
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  json_api do
    type "todo_list"
  end

  graphql do
    type :todo_list
  end

  # pub_sub do
  #   module MyAppWeb.Endpoint
  #   prefix "todo_list"

  #   publish :create, ["created", :user_id]
  #   publish :updated, ["created", :user_id]
  #   publish :destroy, ["destroyed", :user_id]
  # end
end
