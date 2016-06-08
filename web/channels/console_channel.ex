defmodule TapRacer.ConsoleChannel do
  use Phoenix.Channel

  def join("console", _message, socket) do
    {:ok, socket}
  end

  def handle_out("join", payload, socket) do
    push socket, "join", payload
    {:noreply, socket}
  end

  def handle_out("terminate", payload, socket) do
    push socket, "terminate", payload
    {:noreply, socket}
  end

  def handle_out("tap", payload, socket) do
    push socket, "tap", payload
    {:noreply, socket}
  end
end
