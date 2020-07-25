defmodule TapRacer.GameTest do
  use ExUnit.Case, async: true

  setup do
    game = start_supervised!({TapRacer.Game, [id: "00000000"]})
    %{game: game}
  end

  test "state/2 for empty game has empty player map", %{game: game} do
    assert GenServer.call(game, :state) |> Map.fetch!(:players) == %MapSet{}
  end

  test "join/2 successfully adds player to player map", %{game: game} do
    assert TapRacer.Game.join(game, "aaaaaaaa") == :ok

    assert GenServer.call(game, :state)
           |> Map.fetch!(:players)
           |> MapSet.member?("aaaaaaaa")
  end

  test "join/2 fails with a player with duplicate id already joined", %{game: game} do
    assert TapRacer.Game.join(game, "aaaaaaaa") == :ok
    assert TapRacer.Game.join(game, "aaaaaaaa") == :error
  end

  test "notify/2 makes the first time caller the winner", %{game: game} do
    TapRacer.Game.join(game, "aaaaaaaa")
    assert TapRacer.Game.notify(game, "aaaaaaaa") == :win
    assert GenServer.call(game, :state) |> Map.fetch!(:winner) == "aaaaaaaa"
  end

  test "notify/2 fails if player hasn't joined", %{game: game} do
    assert TapRacer.Game.notify(game, "88888888") == :error
  end

  test "notify/2 makes the second time caller the loser", %{game: game} do
    TapRacer.Game.join(game, "aaaaaaaa")
    TapRacer.Game.join(game, "bbbbbbbb")
    TapRacer.Game.notify(game, "aaaaaaaa")
    assert TapRacer.Game.notify(game, "bbbbbbbb") == :lose
    assert GenServer.call(game, :state) |> Map.fetch!(:winner) == "aaaaaaaa"
  end
end
