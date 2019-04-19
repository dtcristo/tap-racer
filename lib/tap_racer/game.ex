defmodule TapRacer.Game do
  use GenServer

  # Client

  def start_link(args) do
    IO.puts("TapRacer.Game start_link/1")
    IO.inspect(args)
    id = Keyword.fetch!(args, :id)
    opts = [name: TapRacer.Game.Registry.name(id)]
    GenServer.start_link(__MODULE__, initial_state(id), opts)
  end

  defp initial_state(id) do
    %{id: id, players: MapSet.new()}
  end

  # def join(game) do
  #   GenServer.call(game, :join)
  # end

  # Server (callbacks)

  @impl true
  def init(state) do
    IO.puts("TapRacer.Game init/1")
    IO.inspect(state)
    {:ok, state}
  end

  # @impl true
  # def handle_call(:join, _from, state) do
  #   {:reply, Map.keys(state), state}
  # end
end
