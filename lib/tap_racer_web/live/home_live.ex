defmodule TapRacerWeb.HomeLive do
  use TapRacerWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: TapRacer.Game.subscribe()
    game_states = Enum.map(TapRacer.games(), fn game -> TapRacer.Game.state(game) end)
    {:ok, assign(socket, :game_states, game_states)}
  end

  @impl true
  def handle_info({:game_created, game_state}, socket) do
    {:noreply, update(socket, :game_states, fn game_states -> [game_state | game_states] end)}
  end

  @impl true
  def handle_event("create_game", _, socket) do
    {:ok, _game} = TapRacer.create_game()
    {:noreply, socket}
  end
end
