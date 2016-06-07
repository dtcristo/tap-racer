defmodule TapRacer.TapChannel do
  use Phoenix.Channel

  def join("taps:anonymous", _message, socket) do
    {:ok, socket}
  end

  def handle_in("tap", %{"body" => body}, socket) do
    broadcast! socket, "tap", %{body: body}
    {:noreply, socket}
  end

  def handle_out("tap", payload, socket) do
    push socket, "tap", payload
    {:noreply, socket}
  end
end
