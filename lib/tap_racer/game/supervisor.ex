defmodule TapRacer.Game.Supervisor do
  use DynamicSupervisor

  def start_link(_args) do
    IO.puts("TapRacer.Game.Supervisor start_link/1")
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child do
    spec = {TapRacer.Game, id: unique_id()}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_args) do
    IO.puts("TapRacer.Game.Supervisor init/1")
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp unique_id do
    id =
      :rand.uniform(0xFF_FFFF_FFFF)
      |> Integer.to_string(32)
      |> String.downcase()
      |> String.pad_leading(8, "0")

    if TapRacer.Game.Registry.exists?(id) do
      unique_id()
    else
      id
    end
  end
end
