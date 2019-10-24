defmodule OgetartsWeb.Router do
  use OgetartsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug OgetartsWeb.Plugs.PutUserToken
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OgetartsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/games/:name", PageController, :game
    post "/games", PageController, :join
  end

  # Other scopes may use custom stacks.
  # scope "/api", OgetartsWeb do
  #   pipe_through :api
  # end
end
