defmodule RavioliCook.Router do
  use RavioliCook.Web, :router

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

  scope "/", RavioliCook do
    pipe_through :browser # Use the default browser stack

    get "/test/job", TestController, :job
    get "/", PageController, :index
  end

  scope "/api", RavioliCook do
    pipe_through :api

  end
end
