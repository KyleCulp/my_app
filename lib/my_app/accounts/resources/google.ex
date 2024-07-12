defmodule MyApp.Accounts.Google do
  alias Ash.Type.Boolean

  use Ash.Resource,
    data_layer: :embedded,
    embed_nil_values?: false

  @type t :: %__MODULE__{
          email: String.t(),
          email_verified: Ash.Type.Boolean.t(),
          family_name: String.t(),
          given_name: String.t(),
          name: String.t(),
          google_hd: String.t(),
          picture: String.t(),
          sub: String.t(),
          created_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  attributes do
    attribute :email, :ci_string, allow_nil?: true, public?: true
    attribute :email_verified, :boolean, allow_nil?: true
    attribute :family_name, :string, allow_nil?: true
    attribute :given_name, :string, allow_nil?: true
    attribute :name, :string, allow_nil?: true
    attribute :google_hd, :string, allow_nil?: true
    attribute :picture, :string, allow_nil?: true
    attribute :sub, :string, allow_nil?: true
    attribute :user_info, :map, allow_nil?: true

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  identities do
    identity :email, [:email]
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end
end
