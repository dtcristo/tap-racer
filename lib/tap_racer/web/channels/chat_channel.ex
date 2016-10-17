defmodule TapRacer.ChatChannel do
  use TapRacer.Web, :channel

  def join("chat:lobby", _params, socket) do
    {:ok, socket}
  end
  def join("chat:secret", _params, socket) do
    {:error, "You don't have permission!"}
  end
  def join("chat:" <> room, _params, socket) do
    {:ok, socket}
  end

  def handle_in("new_msg", %{"name" => name, "text" => text}, socket) do
    safe_name = elem(Phoenix.HTML.html_escape(name), 1)
    safe_text = elem(Phoenix.HTML.html_escape(text), 1)
    broadcast(socket, "new_msg", %{"name" => safe_name, "text" => safe_text})
    {:noreply, assign(socket, :name, safe_name)}
  end

  intercept ["new_msg"]

  def handle_out("new_msg", %{"text" => text} = payload, socket) do
    modified_payload =
      if socket.assigns.name == "Bob" do
        %{payload | "text" => String.upcase(text)}
      else
        payload
      end
    push(socket, "new_msg", modified_payload)
    {:noreply, socket}
  end

  def terminate(_reason, _socket) do
  end
end
