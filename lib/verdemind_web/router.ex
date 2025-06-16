defmodule VerdemindWeb.Router do
  use VerdemindWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VerdemindWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", VerdemindWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/generate-plant", GeneratePlantLive

    live "/plants", PlantLive.Index, :index
    live "/plants/new", PlantLive.Index, :new
    live "/plants/:id/edit", PlantLive.Index, :edit

    live "/plants/:id", PlantLive.Show, :show
    live "/plants/:id/show/edit", PlantLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", VerdemindWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:verdemind, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VerdemindWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
