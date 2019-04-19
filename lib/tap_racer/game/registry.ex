defmodule TapRacer.Game.Registry do
  def child_spec(args) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [args]},
      type: :supervisor,
    }
  end

  def start_link(_args) do
    IO.puts("TapRacer.Game.Registry start_link/1")
    Registry.start_link(keys: :unique, name: __MODULE__)
  end

  def name(id) do
    {:via, Registry, {__MODULE__, id}}
  end

  def lookup(id) do
    Registry.lookup(__MODULE__, id)
  end

  def find(id) do
    case lookup(id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def value(id) do
    case lookup(id) do
      [{_, value}] -> value
      [] -> nil
    end
  end

  def exists?(id) do
    find(id) != nil
  end

  def count do
    Registry.count(__MODULE__)
  end
end
