defmodule MyApp.Kanbans.KanbanCollaborator do
  use Ash.Resource,
    domain: MyApp.Kanbans,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "The collaborators that have some form of access to a Kanban."
    plural_name :kanban_collaborators
  end

  postgres do
    table "kanban_collaborators"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :role, :atom do
      constraints one_of: [:admin, :write, :read]
      allow_nil? false
      always_select? true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, MyApp.Accounts.User, allow_nil?: false
    belongs_to :kanban, MyApp.Kanbans.Kanban, allow_nil?: false
  end

  actions do
    defaults [:read, :destroy]

    create :create do
      primary? true
      change relate_actor(:user)
    end

    update :update do
      primary? true
      change relate_actor(:user)
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
      authorize_if relates_to_actor_via(:user)
    end

    policy action_type(:destroy) do
      authorize_if relates_to_actor_via(:user)
    end
  end

  # pub_sub do
  #   module MyAppWeb.Endpoint
  #   prefix "todo_list"

  #   publish :create, ["created", :user_id]
  #   publish :updated, ["created", :user_id]
  #   publish :destroy, ["destroyed", :user_id]
  # end
end
