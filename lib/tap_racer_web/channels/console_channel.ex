defmodule TapRacerWeb.ConsoleChannel do
  use Phoenix.Channel

  def join("console", _params, socket) do
    {:ok, socket}
  end
end
