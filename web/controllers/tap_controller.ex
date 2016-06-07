defmodule TapRacer.TapController do
  use TapRacer.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def taps(conn, _params) do
    render conn, "taps.html"
  end
end
