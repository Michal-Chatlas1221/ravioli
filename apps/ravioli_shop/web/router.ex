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

  
  pipeline :authenticated do
    plug RavioliShop.Plugs.AuthenticateUser
  end

  scope "/", RavioliShop do
    pipe_through :browser

    get "/", PageController, :index

  end

  scope "/api", RavioliShop do
    pipe_through :api

    post "/sign_in", AuthController, :sign_in
    post "/sign_up", AuthController, :sign_up    
  end

  scope "/api", RavioliShop do
    pipe_through [:api, :authenticated]

    resources "/jobs", JobController, only: [:create, :index, :show, :update, :delete]
  end  
end
