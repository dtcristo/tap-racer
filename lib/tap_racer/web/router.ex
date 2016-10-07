defmodule TapRacer.Router do
  use TapRacer.Web, :router

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

  scope "/", TapRacer do
    pipe_through :browser # Use the default browser stack

    get "/", TapController, :index
    get "/console", TapController, :console
    get "/play", TapController, :play
  end

  # Other scopes may use custom stacks.
  # scope "/api", TapRacer do
  #   pipe_through :api
  # end
end
