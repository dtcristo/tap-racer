defmodule TapRacer.Game.Player do
  use GenServer

  # Client

  def start_link(args) do
    GenServer.start_link(__MODULE__, initial_state(nil, nil), args)
  end

  defp initial_state(id, game) do
    %{id: id, game: game, tap_count: 0}
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
    %{id: _, game: _, tap_count: tap_count} = state

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
