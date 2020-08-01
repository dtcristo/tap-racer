defmodule TapRacerWeb.RoomLive do
  use TapRacerWeb, :live_view

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    id = String.downcase(id)
    room = TapRacer.room(id)

    if room do
      if connected?(socket), do: TapRacer.subscribe("room:#{id}")

      {:ok,
       socket
       |> assign(:id, id)
       |> assign(:room, room)
       |> assign(:qr_code, qr_code(socket, id))}
    else
      {:ok,
       socket
       |> put_flash(:error, "Room not found")
       |> push_redirect(to: Routes.home_path(socket, :index))}
    end
  end

  # @impl true
  # def handle_info({:room_created, room_state}, socket) do
  #   {:noreply, update(socket, :room_states, fn room_states -> [room_state | room_states] end)}
  # end

  # @impl true
  # def handle_event("create_room", _, socket) do
  #   {:ok, _room} = TapRacer.create_room()
  #   {:noreply, socket}
  # end

  defp qr_code(socket, id) do
    Routes.room_url(socket, :index, id)
    |> EQRCode.encode()
    |> EQRCode.svg(width: 120)
    |> String.replace(~s(<?xml version="1.0" standalone="yes"?>), "")
  end
end
