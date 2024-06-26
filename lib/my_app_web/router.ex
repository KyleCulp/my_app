defmodule MyAppWeb.Router do
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
  end

  # Auth Routes
  scope "/", MyAppWeb do
    pipe_through :auth_live

    auth_routes_for MyApp.Accounts.User, to: AuthController
    # sign_in_route(register_path: "/register", reset_path: "/reset")
    sign_out_route AuthController
    reset_route []
    # sign_in_route(on_mount: [{MyAppWeb.LiveUserAuth, :live_no_user}])

    ash_authentication_live_session :maybe_authenticated,
      on_mount: {MyAppWeb.LiveUserAuth, :live_no_user} do
      live "/login", AuthLive.Index, :login
      live "/register", AuthLive.Index, :register
    end
  end

  # Deadview Routes
  scope "/", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  # Live Routes
  scope "/", MyAppWeb do
    pipe_through [:browser]
    # ash_authentication_live_session :authentication_required,
    #   on_mount: {MyAppWeb.LiveUserAuth, :live_user_required} do
    ash_authentication_live_session :authenticated do
      live "/todo_lists", TodoListLive.Index, :index
      live "/todo_lists/new", TodoListLive.Index, :new
      live "/todo_lists/:id/edit", TodoListLive.Index, :edit

      live "/todo_lists/:id", TodoListLive.Show, :show
      live "/todo_lists/:id/show/edit", TodoListLive.Show, :edit
    end
  end

  # API Routes
  scope "/" do
    pipe_through(:api)

    forward "/api/swaggerui",
            OpenApiSpex.Plug.SwaggerUI,
            path: "/api/open_api",
            title: "Myapp's JSON-API - Swagger UI",
            default_model_expand_depth: 4

    forward "/api/redoc",
            Redoc.Plug.RedocUI,
            spec_url: "/api/open_api"

    forward "/api", MyAppWeb.JsonApiRouter
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
