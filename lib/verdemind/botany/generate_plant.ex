defmodule Verdemind.Botany.GeneratePlant do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
  end

  def changeset(generate_plant, attrs \\ %{}) do
    generate_plant
    |> cast(attrs, [:name])
    |> validate_required([:name])
    # Most plant names are in the range of 3-60 characters.
    |> validate_length(:name, min: 3, max: 60)
  end
end
