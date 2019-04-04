defmodule TapRacerWeb.PlayChannel do
  use Phoenix.Channel

  def join("play", %{"name" => name}, socket) do
    safe_name = elem(Phoenix.HTML.html_escape(name), 1)
    user_id = UUID.uuid4()

    TapRacerWeb.Endpoint.broadcast(
      "console",
      "user_join",
      %{name: safe_name, user_id: user_id}
    )

    socket = socket |> assign(:name, safe_name) |> assign(:user_id, user_id)
    {:ok, socket}
  end

  def terminate(_reason, socket) do
    TapRacerWeb.Endpoint.broadcast(
      "console",
      "user_terminate",
      %{user_id: socket.assigns.user_id}
    )
  end

  def handle_in("tap", _payload, socket) do
    TapRacerWeb.Endpoint.broadcast(
      "console",
      "user_tap",
      %{name: socket.assigns.name, user_id: socket.assigns.user_id}
    )

    {:noreply, socket}
  end
end
