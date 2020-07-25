defmodule TapRacer.Game do
  use GenServer

  # Client

  def start_link(args) do
    id = Keyword.fetch!(args, :id)
    opts = [name: TapRacer.GameRegistry.name(id)]
    GenServer.start_link(__MODULE__, initial_state(id), opts)
  end

  defp initial_state(id) do
    %{id: id, player_ids: MapSet.new(), winner: nil}
  end

  def join(game, player_id) do
    GenServer.call(game, {:join, player_id})
  end

  def notify(game, player_id) do
    GenServer.call(game, {:notify, player_id})
  end

  def state(game) do
    GenServer.call(game, :state)
  end

  # Server (callbacks)

  @impl true
  def init(state) do
    TapRacer.broadcast(state, :game_created, "games")
    {:ok, state}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:join, player_id}, _from, state) do
    if MapSet.member?(state.player_ids, player_id) do
      {:reply, :error, state}
    else
      new_player_ids = MapSet.put(state.player_ids, player_id)
      {:reply, :ok, Map.put(state, :player_ids, new_player_ids)}
    end
  end

  @impl true
  def handle_call({:notify, player_id}, _from, state) do
    if MapSet.member?(state.player_ids, player_id) do
      case state.winner do
        nil -> {:reply, :win, Map.put(state, :winner, player_id)}
        _winner -> {:reply, :lose, state}
      end
    else
      {:reply, :error, state}
    end
  end
end
