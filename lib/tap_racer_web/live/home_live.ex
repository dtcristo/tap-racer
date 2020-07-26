defmodule TapRacerWeb.HomeLive do
  use TapRacerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: TapRacer.subscribe("rooms")
    room_states = Enum.map(TapRacer.rooms(), fn room -> TapRacer.Room.state(room) end)
    {:ok, assign(socket, :room_states, room_states), temporary_assigns: [room_states: []]}
  end

  @impl true
  def handle_info({:room_created, room_state}, socket) do
    {:noreply, update(socket, :room_states, fn room_states -> [room_state | room_states] end)}
  end

  @impl true
  def handle_event("create_room", _, socket) do
    {:ok, room} = TapRacer.create_room()
    room_state = TapRacer.Room.state(room)
    {:noreply, push_redirect(socket, to: Routes.room_path(socket, :index, room_state.id))}
  end
end
