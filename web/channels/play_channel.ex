defmodule TapRacer.PlayChannel do
  use Phoenix.Channel

  def join("play", %{"username" => username}, socket) do
    IO.puts "Join: #{username}"
    TapRacer.Endpoint.broadcast! "console", "join", %{username: username}
    {:ok, assign(socket, :username, username)}
  end

  def terminate(_reason, socket) do
    username = socket.assigns.username
    IO.puts "Terminate: #{username}"
    TapRacer.Endpoint.broadcast! "console", "terminate", %{username: username}
  end

  def handle_in("tap", _message, socket) do
    username = socket.assigns.username
    IO.puts "Tap: #{username}"
    TapRacer.Endpoint.broadcast! "console", "tap", %{username: username}
    {:noreply, socket}
  end
end
