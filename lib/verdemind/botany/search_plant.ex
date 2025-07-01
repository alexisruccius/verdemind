defmodule Verdemind.Botany.SearchPlant do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :query, :string
  end

  def changeset(search_plant, attrs \\ %{}) do
    search_plant
    |> cast(attrs, [:query])
  end
end
