defmodule MyAppWeb.Router do
  alias MyAppWeb.V1.RegistrationController
  # alias AshJsonApi.Controllers.Index
  # alias MyAppWeb.TodoListLive
  use MyAppWeb, :router
  use AshAuthentication.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :load_from_session
  end

  pipeline :auth_live do
    plug :browser
    plug :put_root_layout, html: {MyAppWeb.Layouts, :auth_root}
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
    plug :get_actor_from_token
    # plug MyAppWeb.Plugs.GetActorFromToken
  end

  pipeline :api_v1 do
    plug :accepts, ["json"]
  end

  pipeline :api_v1_authorized do
    plug :accepts, ["json"]
    plug MyAppWeb.V1.Plugs.Session
  end

  # pipeline :graphql do
  #   plug :api
  #   plug AshGraphql.Plug
  # end

  # scope "/" do
  #   pipe_through [:graphql]

  #   forward "/gql",
  #           Absinthe.Plug,
  #           schema: Module.concat(["MyApp.GraphqlSchema"])

  #   forward "/playground",
  #           Absinthe.Plug.GraphiQL,
  #           schema: Module.concat(["MyApp.GraphqlSchema"]),
  #           interface: :playground
  # end

  scope "/api/v1/", MyAppWeb.V1 do
    pipe_through :api_v1

    resources "/register", RegistrationController,
      singleton: true,
      only: [:create]

    resources "/session", SessionController,
      singleton: true,
      only: [:show, :create, :delete]

    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1" do
    pipe_through :api_v1_authorized
    # get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    forward "/swagger",
            OpenApiSpex.Plug.SwaggerUI,
            path: "/api/v1/open_api",
            title: "Myapp's JSON-API - Swagger UI",
            default_model_expand_depth: 4

    forward "/redoc",
            Redoc.Plug.RedocUI,
            spec_url: "/api/v1/open_api"

    forward "/", MyAppWeb.V1.JsonAPIRouter
  end

  # scope "/", MyAppWeb do
  #   pipe_through :api
  #   # sign_in_route
  #   sign_out_route AuthJsonController
  #   auth_routes_for MyApp.Accounts.User, to: AuthJsonController
  #   # reset_route
  # end

  # API Routes
  # scope "/" do
  #   pipe_through(:api)
  #   # auth_routes_for MyApp.Accounts.User, to: MyAppWeb.AuthController

  #   forward "/api/swagger",
  #           OpenApiSpex.Plug.SwaggerUI,
  #           path: "/open_api",
  #           title: "Myapp's JSON-API - Swagger UI",
  #           default_model_expand_depth: 4

  #   forward "/api/redoc",
  #           Redoc.Plug.RedocUI,
  #           spec_url: "/open_api"

  #   forward "/", MyAppWeb.JsonApiRouter
  # end

  def extract_user_id(jwt) do
    case jwt["sub"] do
      "user?id=" <> user_id -> user_id
      _ -> :error
    end
  end

  def verify_token(token) do
    case AshAuthentication.Jwt.verify(token, :my_app) do
      {:ok, jwt, _user_module} -> jwt
      _ -> :error
    end
  end

  def get_user(token) do
    user_id =
      token
      |> verify_token()
      |> extract_user_id()

    MyApp.Accounts.User |> Ash.get(user_id)
  end

  def get_actor_from_token(conn, _opts) do
    with ["" <> token] <- get_req_header(conn, "authorization"),
         {:ok, user} <- get_user(token) do
      conn |> Ash.PlugHelpers.set_actor(user)
    else
      _ ->
        conn
    end
  end

  # Dev Routes: Enable LiveDashboard and Swoosh mailbox preview in development
  # if Application.compile_env(:my_app, :dev_routes) do
  #   # If you want to use the LiveDashboard in production, you should put
  #   # it behind authentication and allow only admins to access it.
  #   # If your application does not have an admins-only section yet,
  #   # you can use Plug.BasicAuth to set up some basic authentication
  #   # as long as you are also using SSL (which you should anyway).
  #   import Phoenix.LiveDashboard.Router

  #   scope "/dev" do
  #     pipe_through :browser

  #     live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
  #     forward "/mailbox", Plug.Swoosh.MailboxPreview
  #   end
  # end
end
