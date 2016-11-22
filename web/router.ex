defmodule Ravioli.Router do
  use Ravioli.Web, :router

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
    plug Ravioli.Plugs.AuthenticateUser
  end

  scope "/", Ravioli do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

  end

  scope "/api", Ravioli do
    pipe_through :api

    post "/sign_in", AuthController, :sign_in
    post "/sign_up", AuthController, :sign_up    
  end

  scope "/api", Ravioli do
    pipe_through [:api, :authenticated]

    resources "/jobs", JobController, only: [:create, :index]
  end  
end
