defmodule TapRacer.Player do
  use GenServer

  # Client

  def start_link(_args) do
    GenServer.start_link(__MODULE__, initial_state(nil, nil))
  end

  defp initial_state(id, room) do
    %{id: id, room: room, tap_count: 0}
  end

  def state(player) do
    GenServer.call(player, :state)
  end

  def tap(player) do
    GenServer.cast(player, :tap)
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
  def handle_cast(:tap, %{id: _, room: _, tap_count: tap_count} = state) do
    tap_count =
      cond do
        tap_count >= 100 ->
          tap_count

        tap_count == 99 ->
          IO.puts("hello")
          100

        true ->
          tap_count + 1
      end

    {:noreply, Map.put(state, :tap_count, tap_count)}
  end
end
