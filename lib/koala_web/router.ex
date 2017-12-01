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
    pipe_through :browser
    resources "/categories", CategoryController
    resources "/publications", PublicationController
    resources "/images", ImageController
  end

  scope "/", KoalaWeb do
    pipe_through :browser
    get "/:category_slug/:publication_slug", PublicController, :show
    get "/", PublicController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", KoalaWeb do
  #   pipe_through :api
  # end
end
