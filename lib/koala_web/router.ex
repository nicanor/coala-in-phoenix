defmodule KoalaWeb.Router do
  use KoalaWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :admin do
    plug(KoalaWeb.Authenticate)
    plug :put_layout, {KoalaWeb.LayoutView, :admin}
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/admin", KoalaWeb do
    pipe_through([:browser, :admin])

    get("/", PublicationController, :index)
    resources("/categories", CategoryController, except: [:index])
    resources("/publications", PublicationController)
    resources("/images", ImageController)
    resources("/users", UserController, only: [:index, :edit, :update, :delete])
  end

  scope "/", KoalaWeb do
    pipe_through(:browser)
    get("/login", AuthController, :new)
    post("/login", AuthController, :create)
    delete("/logout", AuthController, :delete)
    get("/registrarme", RegistrationController, :register)
    get("/registro_exitoso", RegistrationController, :success)
    post("/registrarme", RegistrationController, :create)
    get("/:category_slug", PublicController, :category)
    get("/:category_slug/:publication_slug", PublicController, :show)
    get("/", PublicController, :index)
  end
end
