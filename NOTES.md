# Phoenix Sockets and Channels

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

This line directs any WebSocket connection at the following path to the UserSocket module.
`ws://localhost:4000/socket # => TapRacer.UserSocket`

* The details for the UserSocket are specified in `lib/web/channels/`

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

`channel/2` allows us to define topics (or rooms) for the socket. In my example I have two topics an each is directed to a different channel module.

`transport/2` allows us to specify the transport protocols accepted by the socket. Only WebSocket is enabled by default, but by enabling `:longpoll` channels can work with older browsers and clients that do not support WebSockets.

`connect/2` is called whenever a new client attempts to make a connection with the server. Authenticate a client before opening the connection. `socket` is a struct analagous to `conn` (for HTTP requests) and represents the state of this connection between the client an the server. `params` are parameters submitted by the client on connection. We can use the params to autenticate the user in some way, we return `{:ok, socket}` on successful authentication otherwise we return `:error`.

`id/1` allows you to identify a socket by a topic string. The can be used if we wanted to forcibly disconnect a user's socket.

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
