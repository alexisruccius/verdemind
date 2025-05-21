defmodule Verdemind.Repo.Migrations.CreatePlants do
  use Ecto.Migration

  def change do
    create table(:plants) do
      add :name, :string
      add :scientific_name, :string
      add :location, :string
      add :native_to, :string
      add :plant_type, :string
      add :environment, :string
      add :light_requirements, :string
      add :soil, :string
      add :height, :string
      add :growth_season, :string
      add :harvesting, :string
      add :how_to_plant, :string
      add :how_to_water, :string
      add :watering_frequency, :string
      add :proliferation, :string
      add :symbiosis_with, :string
      add :uses, :string
      add :common_pests, :string
      add :is_this_a_plant, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
