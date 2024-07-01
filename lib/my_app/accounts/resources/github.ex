defmodule MyApp.Accounts.Github do
  use Ash.Resource,
    data_layer: :embedded,
    embed_nil_values?: false

  attributes do
    attribute :email, :ci_string, allow_nil?: true, public?: true
    attribute :email_verified, :boolean, allow_nil?: true
    attribute :name, :string, allow_nil?: true
    attribute :picture, :string, allow_nil?: true
    attribute :preferred_username, :string, allow_nil?: true
    attribute :profile, :string, allow_nil?: true
    attribute :sub, :integer, allow_nil?: true
    attribute :user_info, :map, allow_nil?: true

    create_timestamp :created_at
    update_timestamp :updated_at
  end
end
