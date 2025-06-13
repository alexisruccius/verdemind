defmodule Verdemind.Repo.Migrations.CreatePlantsUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:plants, [:name])
  end
end
