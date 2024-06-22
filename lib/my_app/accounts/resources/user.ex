defmodule MyApp.Accounts.User do
  use Ash.Resource,
    domain: MyApp.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshJsonApi.Resource],
    authorizers: [Ash.Policy.Authorizer]

  postgres do
    table "users"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: false, sensitive?: true
  end

  relationships do
    has_many :todo_lists, MyApp.Todos.TodoList
  end

  identities do
    identity :unique_email, [:email]
  end

  authentication do
    strategies do
      password :password do
        identity_field :email

        resettable do
          sender MyApp.Accounts.User.Senders.SendPasswordResetEmail
        end
      end
    end

    tokens do
      enabled? true
      token_resource MyApp.Accounts.Token
      signing_secret MyApp.Accounts.Secrets

      # signing_secret fn _, _ ->
      #   Application.fetch_env(:my_app, :token_signing_secret)
      # end
    end
  end

  actions do
    defaults [:read, :destroy]
  end

  json_api do
    type "user"

    # routes do
    #   # on the resource, the `base` applies to all routes
    #   base("/users")

    #   get(:read)
    #   index :read
    #   post(:destroy)
    #   # ...
    # end
  end

  # You can customize this if you wish, but this is a safe default that
  # only allows user data to be interacted with via AshAuthentication.
  policies do
    bypass AshAuthentication.Checks.AshAuthenticationInteraction do
      authorize_if always()
    end

    policy always() do
      forbid_if always()
    end
  end
end
