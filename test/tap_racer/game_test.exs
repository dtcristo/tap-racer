defmodule TapRacer.GameTest do
  use ExUnit.Case, async: true

  setup do
    game = start_supervised!({TapRacer.Game, [id: "00000000"]})
    %{game: game}
  end

  test "state/1 for empty game has empty player map", %{game: game} do
    assert TapRacer.Game.state(game) == %{id: "00000000", players: MapSet.new()}
  end

  test "join/1 adds player to player map", %{game: game} do
    IO.inspect(TapRacer.Game.join(game, "11111111"))
    assert TapRacer.Game.state(game) == %{id: "00000000", players: MapSet.new()}
  end
end
