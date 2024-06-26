# defmodule MyApp.Accounts.UserIdentity do
#   use Ash.Resource,
#     data_layer: AshPostgres.DataLayer,
#     extensions: [AshAuthentication.UserIdentity],
#     domain: MyApp.Accounts

#   postgres do
#     table "user_identities"
#     repo MyApp.Repo
#   end

#   user_identity do
#     user_resource MyApp.Accounts.User
#   end
# end
