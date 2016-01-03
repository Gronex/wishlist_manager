defmodule WishlistManager.Router do
  use WishlistManager.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Guardian.Plug.VerifyHeader
    plug Guardian.Plug.LoadResource
  end

  pipeline :api_auth do
    plug Guardian.Plug.EnsureAuthenticated, handler: WishlistManager.AuthController
  end

  scope "/", WishlistManager do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/auth", WishlistManager do
    pipe_through :api

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :identity_callback
    post "/register", AuthController, :register
  end

  # Other scopes may use custom stacks.
  scope "/api", WishlistManager do
    pipe_through [:api, :api_auth]

    resources "/users", UserController, except: [:new, :edit, :delete, :create]
    resources "/items", ItemController, except: [:new, :edit]
  end
end
