defmodule TapRacer.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "console", TapRacer.ConsoleChannel
  channel "play", TapRacer.PlayChannel
  # channel "chat:*", TapRacer.ChatChannel

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
  #       {:ok, assign(socket, :user, user)}
  #     _other ->
  #       :error
  #   end
  # end
  # def connect(_other, _socket) do: :error

  # Anonymous socket
  def id(_socket), do: nil

  # def id(socket), do: "user_socket:#{socket.assigns.user.id}"
  #
  # # Use to diconnect all sockets for user '123'
  # TapRacer.Endpoint.broadcast("user_socket:123", "disconnect", %{})
end
