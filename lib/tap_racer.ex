defmodule TapRacer do
  @moduledoc """
  TapRacer keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def create_game do
    TapRacer.GameSupervisor.start_child()
  end

  def games do
    TapRacer.GameSupervisor.which_children()
    |> Enum.reverse()
    |> Enum.map(fn {_, game, _, _} -> game end)
  end
end
