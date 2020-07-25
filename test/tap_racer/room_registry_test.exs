defmodule RoomRegistryTest do
  use ExUnit.Case

  alias TapRacer.RoomRegistry
  alias TapRacer.Room

  test "name/1" do
    assert RoomRegistry.name("00000000") == {:via, Registry, {RoomRegistry, "00000000"}}
  end

  test "find/1 when not found returns nil" do
    assert RoomRegistry.find("11111111") == nil
  end

  test "find/1 when found returns pid" do
    {:ok, pid} = Room.start_link(id: "22222222")
    assert RoomRegistry.find("22222222") == pid
  end

  test "exists?/1 when not found returns false" do
    assert RoomRegistry.exists?("33333333") == false
  end

  test "exists?/1 when not found returns true" do
    Room.start_link(id: "44444444")
    assert RoomRegistry.exists?("44444444") == true
  end

  test "count/0 starts at zero" do
    assert RoomRegistry.count() == 0
  end

  test "count/0 returns correct number of rooms" do
    Room.start_link(id: "55555555")
    Room.start_link(id: "66666666")
    assert RoomRegistry.count() == 2
  end
end
