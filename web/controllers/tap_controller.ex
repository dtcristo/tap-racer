defmodule TapRacer.TapController do
  use TapRacer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def console(conn, _params) do
    render conn, "console.html"
  end

  def user(conn, %{"username" => username}) do
    render conn, "user.html", username: username
  end
end
