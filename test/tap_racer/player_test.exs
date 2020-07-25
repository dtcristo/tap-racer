defmodule TapRacer.PlayerTest do
  use ExUnit.Case, async: true

  alias TapRacer.Game
  alias TapRacer.Player

  setup do
    game = start_supervised!({Game, [id: "00000000"]})
    Game.join(game, "aaaaaaaa")
    %{id: _, player_ids: player_ids, winner: _} = Game.state(game)
    [player_id | _] = MapSet.to_list(player_ids)
    %{game: game, player: nil}
  end

  test "player's tap state starts at zero", %{player: player} do
    assert %{id: _, game: _, tap_count: 0} = Player.state(player)
  end

  test "tap/1 increments tap state by one", %{player: player} do
    assert Player.tap(player) == :ok
    assert %{id: _, game: _, tap_count: 1} = Player.state(player)
  end

  test "tap/1 100 times triggers notify, 101th is no-op", %{player: player} do
    Enum.each(1..99, fn _ ->
      assert Player.tap(player) == :ok
    end)

    assert %{id: _, game: _, tap_count: 99} = Player.state(player)
    assert Player.tap(player) == :ok
  end
end
