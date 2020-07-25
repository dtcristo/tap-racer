defmodule TapRacer.RoomTest do
  use ExUnit.Case, async: true

  alias TapRacer.Room

  setup do
    room = start_supervised!({Room, [id: "0000"]})
    %{room: room}
  end

  test "state/2 for empty room has empty player map", %{room: room} do
    assert Room.state(room).player_ids == %MapSet{}
  end

  test "join/2 successfully adds player to player map", %{room: room} do
    assert Room.join(room, "aaaa") == :ok

    assert Room.state(room)
           |> Map.fetch!(:player_ids)
           |> MapSet.member?("aaaa")
  end

  test "join/2 fails with a player with duplicate id already joined", %{room: room} do
    assert Room.join(room, "aaaa") == :ok
    assert Room.join(room, "aaaa") == :error
  end

  test "notify/2 makes the first time caller the winner", %{room: room} do
    Room.join(room, "aaaa")
    assert Room.notify(room, "aaaa") == :win
    assert Room.state(room).winner == "aaaa"
  end

  test "notify/2 fails if player hasn't joined", %{room: room} do
    assert Room.notify(room, "aaaa") == :error
  end

  test "notify/2 makes the second time caller the loser", %{room: room} do
    Room.join(room, "aaaa")
    Room.join(room, "bbbb")
    Room.notify(room, "aaaa")
    assert Room.notify(room, "bbbb") == :lose
    assert Room.state(room).winner == "aaaa"
  end
end
