defmodule MyApp.Accounts do
  use Ash.Domain, extensions: [AshJsonApi.Domain], otp_app: :my_app

  resources do
    resource MyApp.Accounts.User
    resource MyApp.Accounts.Token
  end

  json_api do
    routes do
      # in the domain `base_route` acts like a scope
      base_route "/accounts/user", MyApp.Accounts.User do
        get(:read)
        index :read
        post(:destroy)
      end
    end
  end
end
