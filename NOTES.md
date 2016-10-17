# Phoenix Sockets and Channels

* The Channel abstraction provided by Phoenix allow us to build compelling soft-realtime systems that can be scaled really easily.
* Channels are essentially an abstraction over the WebSocket protocol and allows non-Elixir

## Demo

## WebSocket protocol
* Persistent bi-directional connection between client and server.
* With HTTP, server cannot send data to client without a request.
* Before WebSockets older polling techniques were used for achieving a similar result.

## Sockets
* One connection per client, represented as a Socket in Phoenix. Each socket is a single Elixir process.
* Sockets in Phoenix are defined in the application's Endpoint.

```elixir
defmodule TapRacer.Endpoint do
  use Phoenix.Endpoint, otp_app: :tap_racer

  socket "/socket", TapRacer.UserSocket

  #...
end
```

* This line directs any WebSocket connection at the following path to the UserSocket module. `ws://localhost:4000/socket # => TapRacer.UserSocket`
* The details for the UserSocket are specified in `lib/web/channels/user_socket.ex`

```elixir
defmodule TapRacer.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "console", TapRacer.ConsoleChannel
  channel "play", TapRacer.PlayChannel
  # channel "chat:*", TapRacer.ChatChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
```

* The Socket is responsible for wiring Transports to Channels.
* The `channel` macro allows us to define topics (or rooms) for the socket. In my example I have two topics an each is directed to a different channel module. This is similar to mapping HTTP paths to a controller in the router.
* The `transport` macro allows us to specify the transport protocols accepted by the socket. Only WebSocket is enabled by default, but by enabling `:longpoll` channels can work with older browsers and clients that do not support WebSockets.
* `connect/2` is called whenever a new client attempts to make a connection with the server. Authenticate a client before opening the connection. `socket` is a struct analogous to `conn` (for HTTP requests) and represents the state of this connection between the client an the server. `params` are parameters submitted by the client on connection. We can use the params to authenticate the user in some way, we return `{:ok, socket}` on successful authentication otherwise we return `:error`.
* `id/1` allows you to identify a socket by a topic string. The can be used if we wanted to forcibly disconnect a user's socket.

## Connecting to Socket
* Client libraries for JavaScript, C#, iOS and Android.
* The JavaScript library comes with Phoenix.
* This file is an ES6 module, `socket.js` generated with a new Phoenix app.

```javascript
// assets/js/socket.js
import {Socket} from "phoenix"

let socket = new Socket("/socket", {})
// let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

export default socket
```

* First we import `Socket` from phoenix.
* We create an instance of a Socket specifying the path defined in the endpoint.
* We can optionally provide socket parameters useful for authentication.
* We call `connect()` on the socket and export it from the module for subscribing to a channels later.

## Channels
* Channels allows multiplexing of multiple topics over a single socket.
* A client can subscribe to one or more topics, each of these subscriptions spawn a channel process that communicates the socket process.
* Client-server communication can be across a single WebSocket connection.

```elixir
defmodule TapRacer.ChatChannel do
  use TapRacer.Web, :channel

  intercept ["new_msg"]

  def join("chat:lobby", _params, socket) do
    {:ok, socket}
  end
  def join("chat:secret", _params, socket) do
    {:error, %{reason: "You don't have permission!"}}
  end
  def join("chat:" <> room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in(event, payload, socket) do
    broadcast! socket, "new_msg", payload
    {:noreply, socket}
  end

  def handle_out(event, payload, socket) do
    push socket, "new_msg", payload
    {:noreply, socket}
  end

  def terminate(event, socket) do
  end
end
```

* `join/3` authorises a client to join a channel topic when the client subscribes.
* `handle_in/3` is called when an authorised user sends a message on the channel. Here we might do something with the message, like persist it in a database and broadcast it to all other users.
* `handle_out/3` is called for each subscribed client just before an outbound message is sent. It can be used to customise the message for the specific client, or filtering the message entirely.
* `terminate/2` is called when a client leaves or disconnects from the channel. We can use this to clean up things.

## Joining a Channel

```javascript
let channel = socket.channel("play", {name: name})

$(".tap").on("click touchstart", event => {
  console.log("tap")
  channel.push("tap")
})

channel.join()
  .receive("ok", resp => {
    console.log("Joined 'play' channel", resp)
  })
  .receive("error", resp => {
    console.log("Error joining 'play' channel", resp)
  })

channel.push('new_msg', {body: 'Hello World!'})
```
