defmodule TapRacer.GameSupervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child do
    spec = {TapRacer.Game, id: unique_id()}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  defp unique_id do
    id = TapRacer.Utils.generate_id()

    if TapRacer.GameRegistry.exists?(id) do
      unique_id()
    else
      id
    end
  end
end
