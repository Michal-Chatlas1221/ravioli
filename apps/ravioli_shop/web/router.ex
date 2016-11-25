defmodule RavioliShop.Router do
  use RavioliShop.Web, :router

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

  scope "/", RavioliShop do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  # Other scopes may use custom stacks.
  scope "/api", RavioliShop do
    pipe_through :api

    post "/sign_in", AuthController, :sign_in
    post "/sign_up", AuthController, :sign_up
  end
end
