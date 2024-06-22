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

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_from_bearer
  end

  # scope "/", MyAppWeb do
  #   pipe_through :browser

  #   get "/", PageController, :home
  #   sign_in_route(register_path: "/register", reset_path: "/reset")
  #   sign_out_route AuthController
  #   auth_routes_for MyApp.Accounts.User, to: AuthController
  #   reset_route []
  # end

  # scope "/", MyAppWeb do
  #   pipe_through [:browser]
  #   # ash_authentication_live_session :authentication_required,
  #   #   on_mount: {MyAppWeb.LiveUserAuth, :live_user_required} do
  #   ash_authentication_live_session :authenticated do
  #     live "/todo_lists", TodoListLive.Index, :index
  #     live "/todo_lists/new", TodoListLive.Index, :new
  #     live "/todo_lists/:id/edit", TodoListLive.Index, :edit

  #     live "/todo_lists/:id", TodoListLive.Show, :show
  #     live "/todo_lists/:id/show/edit", TodoListLive.Show, :edit
  #   end

  #   ash_authentication_live_session :authentication_optional,
  #     on_mount: {MyAppWeb.LiveUserAuth, :live_user_optional} do
  #     # live "/", ProjectLive.Index, :index
  #   end
  # end

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

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
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
