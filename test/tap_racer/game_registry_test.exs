defmodule TapRacer.GameRegistryTest do
  use ExUnit.Case

  test "name/1" do
    assert TapRacer.GameRegistry.name("00000000") ==
             {:via, Registry, {TapRacer.GameRegistry, "00000000"}}
  end

  test "find/1 when not found returns nil" do
    assert TapRacer.GameRegistry.find("11111111") == nil
  end

  test "find/1 when found returns pid" do
    {:ok, pid} = TapRacer.Game.start_link(id: "22222222")
    assert TapRacer.GameRegistry.find("22222222") == pid
  end

  test "exists?/1 when not found returns false" do
    assert TapRacer.GameRegistry.exists?("33333333") == false
  end

  test "exists?/1 when not found returns true" do
    TapRacer.Game.start_link(id: "44444444")
    assert TapRacer.GameRegistry.exists?("44444444") == true
  end

  test "count/0 starts at zero" do
    assert TapRacer.GameRegistry.count() == 0
  end

  test "count/0 returns correct number of games" do
    TapRacer.Game.start_link(id: "55555555")
    TapRacer.Game.start_link(id: "66666666")
    assert TapRacer.GameRegistry.count() == 2
  end
end
