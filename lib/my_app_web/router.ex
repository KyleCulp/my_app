defmodule MyAppWeb.Router do
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

  # # Auth Routes
  # scope "/", MyAppWeb do
  #   pipe_through :auth_live

  #   auth_routes_for MyApp.Accounts.User, to: AuthController
  #   # sign_in_route(register_path: "/register", reset_path: "/reset")
  #   sign_out_route AuthController
  #   reset_route []
  #   # sign_in_route(on_mount: [{MyAppWeb.LiveUserAuth, :live_no_user}])

  #   ash_authentication_live_session :maybe_authenticated,
  #     on_mount: {MyAppWeb.LiveUserAuth, :live_no_user} do
  #     live "/login", AuthLive.Index, :login
  #     live "/register", AuthLive.Index, :register
  #   end
  # end

  # Deadview Routes
  # scope "/", MyAppWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  # end

  # Live Routes
  # scope "/", MyAppWeb do
  #   pipe_through [:browser]
  #   # ash_authentication_live_session :authentication_required,
  #   #   on_mount: {MyAppWeb.LiveUserAuth, :live_user_required} do
  #   ash_authentication_live_session :authenticated do
  #     scope "/todo_lists", TodoListLive do
  #       live "/", Index, :index
  #       live "/new", Index, :new
  #       live "/:id/edit", Index, :edit
  #       live "/:id", Show, :show
  #       live "/:id/show/edit", Show, :edit
  #     end

  #     scope "/profile", ProfileLive do
  #       live "/", Index, :index
  #       live "/settings", Settings, :index
  #     end
  #   end
  # end

  scope "/", MyAppWeb do
    pipe_through :api
    # sign_in_route
    sign_out_route AuthJsonController
    auth_routes_for MyApp.Accounts.User, to: AuthJsonController
    # reset_route
  end

  # API Routes
  scope "/" do
    pipe_through(:api)
    # auth_routes_for MyApp.Accounts.User, to: MyAppWeb.AuthController

    forward "/api/swagger",
            OpenApiSpex.Plug.SwaggerUI,
            path: "/open_api",
            title: "Myapp's JSON-API - Swagger UI",
            default_model_expand_depth: 4

    forward "/api/redoc",
            Redoc.Plug.RedocUI,
            spec_url: "/open_api"

    forward "/", MyAppWeb.JsonApiRouter
  end

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
