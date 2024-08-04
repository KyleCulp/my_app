defmodule MyApp.Kanbans.KanbanSize do
  use Ash.Resource,
    domain: MyApp.Kanbans,
    data_layer: AshPostgres.DataLayer,
    authorizers: [Ash.Policy.Authorizer]

  resource do
    description "The size of a kanban item. Customizable for users to create their own size levels regarding the item/task."
    plural_name :kanban_sizes
  end

  postgres do
    table "kanban_sizes"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :ci_string do
      allow_nil? false
      constraints max_length: 64, min_length: 3, trim?: true
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    belongs_to :kanban, MyApp.Kanbans.Kanban, allow_nil?: false
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
