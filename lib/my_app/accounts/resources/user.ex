defmodule MyApp.Accounts.User do
  use Ash.Resource,
    domain: MyApp.Accounts,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshAuthentication, AshJsonApi.Resource]

  postgres do
    table "users"
    repo MyApp.Repo
  end

  attributes do
    uuid_primary_key :id
    attribute :email, :ci_string, allow_nil?: false, public?: true
    attribute :hashed_password, :string, allow_nil?: true, sensitive?: true

    attribute :github, MyApp.Accounts.Github do
      public? true
      # constraints [load: [:full_name]]
    end

    attribute :google, MyApp.Accounts.Google do
      public? true
      # constraints [load: [:full_name]]
    end

    create_timestamp :created_at
    update_timestamp :updated_at
  end

  relationships do
    has_many :todo_lists, MyApp.Todos.TodoList
    # has_one :google_identity, MyApp.Accounts.Identities.Google, destination_attribute: :user_id
  end

  identities do
    identity :unique_email, [:email]
    identity :email, [:email]
    # identity :google, google: [:email]
  end

  authentication do
    strategies do
      password :password do
        identity_field :email
        hashed_password_field :hashed_password
        sign_in_tokens_enabled? true
        confirmation_required? false

        resettable do
          sender MyApp.Accounts.Senders.SendPasswordResetEmail
        end
      end

      github do
        identity_resource MyApp.Accounts.Identities.Github
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
      end

      google do
        identity_resource MyApp.Accounts.Identities.Google
        client_id MyApp.Secrets
        redirect_uri MyApp.Secrets
        client_secret MyApp.Secrets
      end
    end

    tokens do
      enabled? true
      token_resource MyApp.Accounts.Token
      signing_secret MyApp.Secrets
    end
  end

  actions do
    defaults [:read, :update, :destroy]

    read :by_email do
      argument :email, :ci_string do
        allow_nil? false
      end

      get? true
      filter expr(email == ^arg(:email))
    end

    create :register_with_github do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :email

      # change MyApp.Accounts.Changes.SaveOAuthInfo
      change AshAuthentication.GenerateTokenChange
      change AshAuthentication.Strategy.OAuth2.IdentityChange

      change fn changeset, _ ->
        user_info = Ash.Changeset.get_argument(changeset, :user_info)
        IO.inspect(user_info)
        Ash.Changeset.change_attributes(changeset, Map.take(user_info, ["email"]))
      end
    end

    read :sign_in_with_github do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      prepare AshAuthentication.Strategy.OAuth2.SignInPreparation

      filter expr(email == get_path(^arg(:user_info), [:email]))
    end

    create :register_with_google do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      upsert? true
      upsert_identity :email

      change MyApp.Accounts.Changes.SaveOAuthInfo
      change AshAuthentication.GenerateTokenChange
      change AshAuthentication.Strategy.OAuth2.IdentityChange

      change fn changeset, _ ->
        user_info =
          Ash.Changeset.get_argument(changeset, :user_info)

        changeset
        |> Ash.Changeset.change_attributes(Map.take(user_info, ["email"]))
      end
    end

    read :sign_in_with_google do
      argument :user_info, :map, allow_nil?: false
      argument :oauth_tokens, :map, allow_nil?: false
      prepare AshAuthentication.Strategy.OAuth2.SignInPreparation
      # prepare MyApp.Accounts.Changes.StrategyInfo

      filter expr(email == get_path(^arg(:user_info), [:email]))
    end
  end

  calculations do
    calculate :display_name, :string, MyApp.Accounts.Calculations.DisplayName
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
  # policies do
  #   bypass AshAuthentication.Checks.AshAuthenticationInteraction do
  #     authorize_if always()
  #   end

  #   # policy always() do
  #   #   forbid_if always()
  #   # end
  # end
end
