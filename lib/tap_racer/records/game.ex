defmodule TapRacer.Records.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
