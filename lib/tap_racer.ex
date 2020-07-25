defmodule TapRacer do
  @moduledoc """
  TapRacer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias TapRacer.RoomSupervisor
  alias TapRacer.PubSub

  def subscribe(topic) do
    Phoenix.PubSub.subscribe(PubSub, topic)
  end

  def broadcast(payload, event, topic) do
    Phoenix.PubSub.broadcast(PubSub, topic, {event, payload})
  end

  def create_room do
    RoomSupervisor.start_child()
  end

  def rooms do
    RoomSupervisor.which_children()
    |> Enum.reverse()
    |> Enum.map(fn {_, room, _, _} -> room end)
  end
end
