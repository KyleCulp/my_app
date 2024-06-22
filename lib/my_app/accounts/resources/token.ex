defmodule MyApp.Accounts.Token do
  use Ash.Resource,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication.TokenResource],
    # If using policies, enable the policy authorizer:
    # authorizers: [Ash.Policy.Authorizer],
    domain: MyApp.Accounts

  postgres do
    table "tokens"
    repo MyApp.Repo
  end

  # If using policies, add the following bypass:
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end
  # end
end
