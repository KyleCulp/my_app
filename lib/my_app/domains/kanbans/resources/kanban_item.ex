defmodule MyApp.Kanbans.KanbanItem do
  use Ash.Resource,
    domain: MyApp.Kanbans,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  resource do
    description "The Kanban Item which belongs to a Kanban, holding and owning information specific to each kanban entry."
    plural_name :kanban_items
  end

  postgres do
    table "kanban_items"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :ci_string do
      allow_nil? false
      constraints max_length: 64, min_length: 3, trim?: true
    end

    attribute :description, :string
    attribute :estimate, :decimal

    attribute :start_date, :datetime
    attribute :end_date, :datetime
    attribute :archived, :boolean

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :kanban, MyApp.Kanbans.Kanban, allow_nil?: false
    belongs_to :kanban_status, MyApp.Kanbans.KanbanStatus
  end

  actions do
    defaults [:read, :destroy]
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
