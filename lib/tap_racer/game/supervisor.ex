defmodule TapRacer.Game.Supervisor do
  use DynamicSupervisor

  def start_link(opts) do
    IO.puts("TapRacer.Game.Supervisor start_link")
    IO.inspect(opts)
    DynamicSupervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def start_child do
    id = unique_id()
    name = TapRacer.Game.Registry.name(id)
    spec = {TapRacer.Game, ids: id, name: name}
    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(args) do
    IO.puts("TapRacer.Game.Supervisor init")
    IO.inspect(args)
    DynamicSupervisor.init(strategy: :one_for_one, extra_arguments: [args])
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
