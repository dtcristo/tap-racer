defmodule TapRacer.Game.Player do
  use GenServer

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, 0, args)
  end

  def tap(game) do
    GenServer.cast(game, :tap)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast(:tap, state) do
    {:noreply, state + 1}
  end
end
