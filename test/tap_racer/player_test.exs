defmodule TapRacer.PlayerTest do
  use ExUnit.Case, async: true

  setup do
    game = start_supervised!({TapRacer.Game, [id: "00000000"]})
    TapRacer.Game.join(game, "aaaaaaaa")
    %{id: _, player_ids: player_ids, winner: _} = GenServer.call(game, :state)
    [player_id | _] = MapSet.to_list(player_ids)
    %{game: game, player: nil}
  end

  test "player's tap state starts at zero", %{player: player} do
    assert %{id: _, game: _, tap_count: 0} = GenServer.call(player, :state)
  end

  test "tap/1 increments tap state by one", %{player: player} do
    assert TapRacer.Player.tap(player) == :ok
    assert %{id: _, game: _, tap_count: 1} = GenServer.call(player, :state)
  end

  test "tap/1 100 times triggers notify, 101th is no-op", %{player: player} do
    Enum.each(1..99, fn _ ->
      assert TapRacer.Player.tap(player) == :ok
    end)

    assert %{id: _, game: _, tap_count: 99} = GenServer.call(player, :state)
    assert TapRacer.Player.tap(player) == :ok
  end
end
