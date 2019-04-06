defmodule TapRacer.Game do
  use GenServer

  # Client

  def start_link(id, opts) do
    IO.puts("TapRacer.Game start")
    IO.inspect(id)
    IO.inspect(opts)
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
    {:ok, state}
  end

  # @impl true
  # def handle_call(:join, _from, state) do
  #   {:reply, Map.keys(state), state}
  # end
end
