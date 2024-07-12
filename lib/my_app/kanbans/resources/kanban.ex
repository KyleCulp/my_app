defmodule MyApp.Kanbans.Kanban do
  use Ash.Resource,
    domain: MyApp.Kanbans,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer],
    notifiers: [Ash.Notifier.PubSub]

  resource do
    description "The Kanban object which owns all items related to a Kanban instance."
    plural_name :kanbans
  end

  postgres do
    table "kanbans"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string do
      allow_nil? false
      constraints max_length: 64, min_length: 3, trim?: true
    end

    attribute :description, :string
    attribute :readme, :string
    attribute :visibility, :atom, constraints: [one_of: [:public, :collaborators]]
    attribute :archived, :boolean

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :user, MyApp.Accounts.User do
      writable? true
      allow_nil? false
    end

    has_many :kanban_collaborators, MyApp.Kanbans.KanbanCollaborator
    has_many :kanban_items, MyApp.Kanbans.KanbanItem
    has_many :kanban_views, MyApp.Kanbans.KanbanView
    has_many :kanban_statuses, MyApp.Kanbans.KanbanStatus
    has_many :kanban_priorities, MyApp.Kanbans.KanbanPriority
    has_many :kanban_size, MyApp.Kanbans.KanbanSize
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
