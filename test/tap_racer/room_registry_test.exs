defmodule RoomRegistryTest do
  use ExUnit.Case

  alias TapRacer.RoomRegistry
  alias TapRacer.Room

  test "name/1" do
    assert RoomRegistry.name("0000") == {:via, Registry, {RoomRegistry, "0000"}}
  end

  test "find/1 when not found returns nil" do
    assert RoomRegistry.find("1111") == nil
  end

  test "find/1 when found returns pid" do
    {:ok, pid} = Room.start_link(id: "2222")
    assert RoomRegistry.find("2222") == pid
  end

  test "exists?/1 when not found returns false" do
    assert RoomRegistry.exists?("3333") == false
  end

  test "exists?/1 when not found returns true" do
    Room.start_link(id: "4444")
    assert RoomRegistry.exists?("4444") == true
  end

  test "count/0 starts at zero" do
    assert RoomRegistry.count() == 0
  end

  test "count/0 returns correct number of rooms" do
    Room.start_link(id: "5555")
    Room.start_link(id: "6666")
    assert RoomRegistry.count() == 2
  end
end
