defmodule TapRacer.PlayChannel do
  use Phoenix.Channel

  def join("play", %{"name" => name}, socket) do
    IO.puts "Join: #{name}"
    TapRacer.Endpoint.broadcast! "console", "join", %{name: name}
    {:ok, assign(socket, :name, name)}
  end

  def terminate(_reason, socket) do
    name = socket.assigns.name
    IO.puts "Terminate: #{name}"
    TapRacer.Endpoint.broadcast! "console", "terminate", %{name: name}
  end

  def handle_in("tap", _message, socket) do
    name = socket.assigns.name
    IO.puts "Tap: #{name}"
    TapRacer.Endpoint.broadcast! "console", "tap", %{name: name}
    {:noreply, socket}
  end
end
