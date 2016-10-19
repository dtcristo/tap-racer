# Phoenix Sockets and Channels

## Introduction
* I'm David. I'll be talking about Phoenix Channels, how they work, and how you can use them to build a simple multiplayer game.
* Channels allow us to build soft-realtime systems that can be scaled really easily. Channels are essentially an abstraction over the WebSocket protocol and allows non-Elixir clients (such as a browser) to communicate in a similar way to Elixir processes.

## Demo - TapRacer

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
end
```

* The `socket` macro defines a WebSocket upgrade endpoint. It directs connections to the UserSocket module. `ws://localhost:4000/socket`

```elixir
defmodule TapRacer.UserSocket do
  use Phoenix.Socket

  channel "console", TapRacer.ConsoleChannel
  channel "play", TapRacer.PlayChannel
  channel "chat:*", TapRacer.ChatChannel

  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
```

* The Socket is responsible for wiring transports to channels.
* The `channel` macro allows us to define topics (or rooms) for the socket. In my example I have three topics an each is directed to a different channel module. This is similar to mapping HTTP paths to a controller in the router.
* The `transport` macro allows us to specify the transport protocols accepted by the socket. Only WebSocket is enabled by default, but by enabling `:longpoll`, channels can work with older browsers and clients that do not support WebSockets.
* `connect/2` is called whenever a new client attempts to make a connection with the server and is used to authenticate a client before opening the connection. `socket` is a struct analogous to `conn` (for HTTP requests) and represents the state of this connection between the client an the server. The state is persisted within a process for each socket. `params` are parameters submitted by the client on connection. We can use the params to authenticate the user in some way, we return `{:ok, socket}` on successful authentication otherwise we return `:error`.
* `id/1` allows you to identify a socket by a topic string. The can be used if we wanted to forcibly disconnect a user's socket. If returning `nil`, the socket is anonymous.

## Connecting to a Socket
* Client libraries for JavaScript, C#, iOS and Android.
* The JavaScript library comes with Phoenix.
* This file is an ES6 module, `socket.js` generated with a new Phoenix app.

```javascript
// assets/js/socket.js
import {Socket} from "phoenix"

let socket = new Socket("/socket", {})

socket.connect()

export default socket
```

* First we import `Socket` from phoenix.
* We create an instance of a Socket specifying the path defined in the endpoint.
* We can optionally provide socket parameters useful for authentication.
* We call `connect()` on the socket and export it from the module for subscribing to channels later.

## Channels
* Channels are a layer on top of sockets and allow multiplexing of multiple topics over a single socket.
* A client can subscribe to one or more topics, each of these subscriptions spawns a channel process that communicates with the socket process.
* All client-server communication can be across a single WebSocket connection.

```elixir
defmodule TapRacer.ChatChannel do
  use TapRacer.Web, :channel

  def join("chat:secret", _params, socket) do
    {:error, %{reason: "You don't have permission!"}}
  end
  def join("chat:" <> room_id, _params, socket) do
    {:ok, socket}
  end

  def handle_in(event, payload, socket) do
    broadcast(socket, "new_msg", payload)
    {:noreply, socket}
  end

  intercept ["new_msg"]

  def handle_out(event, payload, socket) do
    push(socket, "new_msg", payload)
    {:noreply, socket}
  end

  def terminate(event, socket) do
  end
end
```

* `join/3` authorises a client for a topic when the client subscribes.
* `handle_in/3` is called when an authorised user sends a message on the channel. Here we might do something with the message, like persist it in a database and then broadcast it to all other clients.
* `broadcast/3` will send a message to all clients subscribed to a topic, including the current client.
* `broadcast_from/3` will send a message to all clients exept the current one.
* `push/3` will sends a message to only the current client.
* `handle_out/3` is called for each subscribed client just before an outbound message is sent. It can be used to customise the message for the specific client, or filtering the message entirely. For `handle_out/3` to be triggered, the message must first be intercepted. To do this, a list of events is given to the `intercept` macro.
* `terminate/2` is called when a client leaves or disconnects from the channel. We can use this to clean up things.

## Joining a Channel

```javascript
let channel = socket.channel("chat:lobby", {name: "David"})

channel.on("new_msg", payload => {
  // Render message
})

channel.join()
  .receive("ok", resp => {
    // Join success
  })
  .receive("error", resp => {
    // Join error
  })

// Push a message down the channel
channel.push("new_msg", {text: "Hello World!"})
```

* Add a channel with a topic and join parameters.
* Create callbacks for specific events on the channels.
* Join the channel with callbacks for success and error.
* When we want to send a message to the server, we call `push()` on the channel with the event name and a payload.

## Extra
* Phoenix 1.2 added Presence which is a way to know which clients are online across a cluster of Elixir nodes. It can also be used for service discovery. Maybe someone can talk about this next month.

## Questions?
* Find me, @dtcristo on Twitter and GitHub. Shoot me a tweet or a pull request.
* All the code and notes for tonight are on GitHub. http://github.com/dtcriso/tap-racer.
* I'm a senior developer at Hardhat a digital agency. We're hiring at the moment, looking for some rad developers. We mostly do Rails web-apps but we're always looking into new technologies. We've used Elixir a little but not in anything for production, yet. If you're interested, checkout our website http://hardhat.com.au/ or contact me.
