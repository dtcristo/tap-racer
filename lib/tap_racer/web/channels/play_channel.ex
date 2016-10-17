defmodule TapRacer.PlayChannel do
  use Phoenix.Channel

  def join("play", %{"name" => name}, socket) do
    safe_name = elem(Phoenix.HTML.html_escape(name), 1)
    user_id = UUID.uuid4()
    TapRacer.Endpoint.broadcast(
      "console", "user_join", %{name: safe_name, user_id: user_id}
    )
    {:ok, assign(socket, :user_id, user_id)}
  end

  def terminate(_reason, socket) do
    TapRacer.Endpoint.broadcast(
      "console", "user_terminate", %{user_id: socket.assigns.user_id}
    )
  end

  def handle_in("tap", _payload, socket) do
    TapRacer.Endpoint.broadcast(
      "console", "user_tap", %{user_id: socket.assigns.user_id}
    )
    {:noreply, socket}
  end
end
