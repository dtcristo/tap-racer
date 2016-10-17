defmodule TapRacer.TapController do
  use TapRacer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def console(conn, _params) do
    render conn, "console.html"
  end

  def play(conn, %{"name" => name}),
    do: render conn, "play.html", name: name
  def play(conn, _params),
    do: redirect conn, to: tap_path(conn, :index)

  def chat(conn, %{"room" => room}),
    do: render conn, "chat.html", room: room
  def chat(conn, _params),
    do: redirect conn, to: "/chat/lobby"
end
