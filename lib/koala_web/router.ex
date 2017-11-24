defmodule KoalaWeb.Router do
  use KoalaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", KoalaWeb do
    pipe_through :browser # Use the default browser stack
    resources "/publications", PublicationController
    get "/", PageController, :index
  end

  scope "/", KoalaWeb do
    pipe_through :browser
    get "/sitemap", PageController, :sitemap
    get "/:type/:id", PageController, :show
    get "/", PageController, :index
  end
  # Other scopes may use custom stacks.
  # scope "/api", KoalaWeb do
  #   pipe_through :api
  # end
end
