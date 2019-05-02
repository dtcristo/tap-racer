defmodule TapRacer.Game do
  use GenServer

  # Client

  def start_link(args) do
    id = Keyword.fetch!(args, :id)
    opts = [name: TapRacer.Game.Registry.name(id)]
    GenServer.start_link(__MODULE__, initial_state(id), opts)
  end

  defp initial_state(id) do
    %{id: id, players: MapSet.new()}
  end

  def state(game) do
    GenServer.call(game, :state)
  end

  def join(game, player_id) do
    GenServer.call(game, {:join, player_id})
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
  def handle_call({:join, player_id}, _from, state) do
    {:reply, state, state}
  end
end
