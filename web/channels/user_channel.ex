defmodule TapRacer.UserChannel do
  use Phoenix.Channel

  def join("user", %{"username" => username}, socket) do
    IO.puts "Join: #{username}"
    TapRacer.Endpoint.broadcast! "console", "join", %{username: username}
    {:ok, socket}
  end

  def handle_in("tap", %{"username" => username}, socket) do
    IO.puts "Tap: #{username}"
    TapRacer.Endpoint.broadcast! "console", "tap", %{username: username}
    {:noreply, socket}
  end
end
