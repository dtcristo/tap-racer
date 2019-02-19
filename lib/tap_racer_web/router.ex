defmodule TapRacerWeb.Router do
  use TapRacerWeb, :router

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

  scope "/", TapRacerWeb do
    pipe_through :browser

    get "/", TapController, :index
    get "/console", TapController, :console
    get "/play", TapController, :play
    get "/chat", TapController, :chat
    get "/chat/:room", TapController, :chat
  end

  # Other scopes may use custom stacks.
  # scope "/api", TapRacerWeb do
  #   pipe_through :api
  # end
end
