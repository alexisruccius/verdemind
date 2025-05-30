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
    |> validate_length(:name, min: 3)
  end
end
