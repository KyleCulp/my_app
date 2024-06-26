# defmodule MyApp.Accounts.Profile do
#   use Ash.Resource,
#     domain: MyApp.Accounts,
#     data_layer: AshPostgres.DataLayer,
#     extensions: [AshJsonApi.Resource]

#   postgres do
#     table "profiles"
#     repo MyApp.Repo
#   end

#   attributes do
#     uuid_primary_key :id
#     attribute :profile_picture, :string, public?: true
#     attribute :name, :string, public?: false
#     attribute :username, :string
#     attribute :dob, :date
#     attribute :gender, :atom, constraints: [one_of: [:male, :female, :other]]
#     attribute :public_profile, :boolean, default: false
#   end

#   relationships do
#     belongs_to :user, MyApp.Accounts.User
#   end

#   actions do
#     defaults [:read, :update, :destroy]
#   end

#   json_api do
#     type "profile"

#     # routes do
#     #   # on the resource, the `base` applies to all routes
#     #   base("/users")

#     #   get(:read)
#     #   index :read
#     #   post(:destroy)
#     #   # ...
#     # end
#   end

#   # You can customize this if you wish, but this is a safe default that
#   # only allows user data to be interacted with via AshAuthentication.
#   # policies do
#   #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
#   #     authorize_if always()
#   #   end

#   #   # policy always() do
#   #   #   forbid_if always()
#   #   # end
#   # end
# end
