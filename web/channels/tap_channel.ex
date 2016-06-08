defmodule TapRacer.TapChannel do
  use Phoenix.Channel

  def join("taps:user", _message, socket) do
    {:ok, socket}
  end

  def join("taps:console", _message, socket) do
    {:ok, socket}
  end

  def handle_in("tap", %{"username" => username}, socket) do
    IO.puts "Tap from: #{username}"
    TapRacer.Endpoint.broadcast! "taps:console", "tap", %{username: username}
    {:noreply, socket}
  end

  def handle_out("tap", payload, socket) do
    push socket, "tap", payload
    {:noreply, socket}
  end
end
