defmodule MyApp.Accounts do
  use Ash.Domain, extensions: [AshJsonApi.Domain, AshGraphql.Domain], otp_app: :my_app

  alias MyApp.Accounts.{User, Token}

  resources do
    resource MyApp.Accounts.User
    resource MyApp.Accounts.Token
    # resource MyApp.Accounts.UserIdentity
    resource MyApp.Accounts.Identities.Github
    resource MyApp.Accounts.Identities.Google
  end

  json_api do
    routes do
      base_route "/accounts/user", MyApp.Accounts.User do
        get(:read)
        index :read
        get(:current_user, route: "/current_user")
      end
    end
  end

  graphql do
    authorize? true
    show_raised_errors?(true)
    root_level_errors?(true)

    queries do
      get User, :current_user, :current_user
      read_one(User, :sign_in_with_password, :sign_in_with_password)
    end

    mutations do
    end
  end
end
