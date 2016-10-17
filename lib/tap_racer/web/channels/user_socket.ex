defmodule TapRacer.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "console", TapRacer.ConsoleChannel
  channel "play", TapRacer.PlayChannel
  channel "chat:*", TapRacer.ChatChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Un-authenticated socket
  def connect(_params, socket) do
    {:ok, socket}
  end

  # def connect(%{token: token}, socket) do
  #   case find_user(token) do
  #     {:ok, user} ->
  #       {:ok, assign(socket, :user_id, user.id)}
  #     _other ->
  #       :error
  #   end
  # end
  # def connect(_params, _socket) do: :error

  # Anonymous socket
  def id(_socket), do: nil

  # def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # # Disconnect all user's socket connections and their multiplexed channels
  # TapRacer.Endpoint.broadcast("users_socket:" <> user.id, "disconnect", %{})
end
