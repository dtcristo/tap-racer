defmodule TapRacer.RoomTest do
  use ExUnit.Case, async: true

  alias TapRacer.Room

  setup do
    room = start_supervised!({Room, [id: "00000000"]})
    %{room: room}
  end

  test "state/2 for empty room has empty player map", %{room: room} do
    assert Room.state(room).player_ids == %MapSet{}
  end

  test "join/2 successfully adds player to player map", %{room: room} do
    assert Room.join(room, "aaaaaaaa") == :ok

    assert Room.state(room)
           |> Map.fetch!(:player_ids)
           |> MapSet.member?("aaaaaaaa")
  end

  test "join/2 fails with a player with duplicate id already joined", %{room: room} do
    assert Room.join(room, "aaaaaaaa") == :ok
    assert Room.join(room, "aaaaaaaa") == :error
  end

  test "notify/2 makes the first time caller the winner", %{room: room} do
    Room.join(room, "aaaaaaaa")
    assert Room.notify(room, "aaaaaaaa") == :win
    assert Room.state(room).winner == "aaaaaaaa"
  end

  test "notify/2 fails if player hasn't joined", %{room: room} do
    assert Room.notify(room, "88888888") == :error
  end

  test "notify/2 makes the second time caller the loser", %{room: room} do
    Room.join(room, "aaaaaaaa")
    Room.join(room, "bbbbbbbb")
    Room.notify(room, "aaaaaaaa")
    assert Room.notify(room, "bbbbbbbb") == :lose
    assert Room.state(room).winner == "aaaaaaaa"
  end
end
