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
    assert TapRacer.Game.join(game, "11111111") == :ok

    assert GenServer.call(game, :state)
           |> Map.fetch!(:players)
           |> MapSet.member?("11111111")
  end

  test "notify/2 makes the first time caller the winner", %{game: game} do
    TapRacer.Game.join(game, "11111111")
    assert TapRacer.Game.notify(game, "11111111") == :win
    assert GenServer.call(game, :state) |> Map.fetch!(:winner) == "11111111"
  end

  test "notify/2 makes the second time caller the loser", %{game: game} do
    TapRacer.Game.join(game, "11111111")
    TapRacer.Game.join(game, "22222222")
    TapRacer.Game.notify(game, "11111111")
    assert TapRacer.Game.notify(game, "22222222") == :lose
    assert GenServer.call(game, :state) |> Map.fetch!(:winner) == "11111111"
  end
end
