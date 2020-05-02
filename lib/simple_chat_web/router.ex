defmodule SimpleChatWeb.Router do
  use SimpleChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery, with: :clear_session
    plug :put_secure_browser_headers
    plug SimpleChatWeb.Plugs.Auth
    plug SimpleChatWeb.Plugs.NodeInfo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleChatWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/:id", PageController, :index
    post "/set-name", PageController, :create
    post "/kill-session", PageController, :kill
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleChatWeb do
  #   pipe_through :api
  # end
end
