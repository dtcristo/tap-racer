defmodule TapRacer.Game.PlayerTest do
  use ExUnit.Case, async: true

  setup do
    player = start_supervised!({TapRacer.Game.Player, []})
    %{player: player}
  end

  test "player's tap state starts at zero", %{player: player} do
    assert GenServer.call(player, :state) == 0
  end

  test "tap/1 increments tap state by one", %{player: player} do
    assert TapRacer.Game.Player.tap(player) == :ok
    assert GenServer.call(player, :state) == 1
  end
end
