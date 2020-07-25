defmodule TapRacer.RoomSupervisor do
  use DynamicSupervisor

  # Client

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_child do
    spec = {TapRacer.Room, id: unique_id()}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def which_children do
    DynamicSupervisor.which_children(__MODULE__)
  end

  defp unique_id do
    id = TapRacer.Utils.generate_id()

    if TapRacer.RoomRegistry.exists?(id) do
      unique_id()
    else
      id
    end
  end

  # Server (callbacks)

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
