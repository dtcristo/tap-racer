defmodule TapRacer.Game.RegistryTest do
  use ExUnit.Case, async: true

  test "name/1" do
    assert TapRacer.Game.Registry.name("00000000") ==
             {:via, Registry, {TapRacer.Game.Registry, "00000000"}}
  end

  test "find/1 when not found returns nil" do
    assert TapRacer.Game.Registry.find("11111111") == nil
  end

  test "find/1 when found returns pid" do
    {:ok, pid} = TapRacer.Game.start_link(id: "22222222")
    assert TapRacer.Game.Registry.find("22222222") == pid
  end

  test "exists?/1 when not found returns false" do
    assert TapRacer.Game.Registry.exists?("33333333") == false
  end

  test "exists?/1 when not found returns true" do
    TapRacer.Game.start_link(id: "44444444")
    assert TapRacer.Game.Registry.exists?("44444444") == true
  end

  test "count/0 starts at zero" do
    assert TapRacer.Game.Registry.count() == 0
  end

  test "count/0 returns correct number of games" do
    TapRacer.Game.start_link(id: "55555555")
    TapRacer.Game.start_link(id: "66666666")
    assert TapRacer.Game.Registry.count() == 2
  end
end
