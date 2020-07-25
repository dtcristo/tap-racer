defmodule TapRacer.GameTest do
  use ExUnit.Case, async: true

  alias TapRacer.Game

  setup do
    game = start_supervised!({Game, [id: "00000000"]})
    %{game: game}
  end

  test "state/2 for empty game has empty player map", %{game: game} do
    assert Game.state(game).player_ids == %MapSet{}
  end

  test "join/2 successfully adds player to player map", %{game: game} do
    assert Game.join(game, "aaaaaaaa") == :ok

    assert Game.state(game)
           |> Map.fetch!(:player_ids)
           |> MapSet.member?("aaaaaaaa")
  end

  test "join/2 fails with a player with duplicate id already joined", %{game: game} do
    assert Game.join(game, "aaaaaaaa") == :ok
    assert Game.join(game, "aaaaaaaa") == :error
  end

  test "notify/2 makes the first time caller the winner", %{game: game} do
    Game.join(game, "aaaaaaaa")
    assert Game.notify(game, "aaaaaaaa") == :win
    assert Game.state(game).winner == "aaaaaaaa"
  end

  test "notify/2 fails if player hasn't joined", %{game: game} do
    assert Game.notify(game, "88888888") == :error
  end

  test "notify/2 makes the second time caller the loser", %{game: game} do
    Game.join(game, "aaaaaaaa")
    Game.join(game, "bbbbbbbb")
    Game.notify(game, "aaaaaaaa")
    assert Game.notify(game, "bbbbbbbb") == :lose
    assert Game.state(game).winner == "aaaaaaaa"
  end
end
