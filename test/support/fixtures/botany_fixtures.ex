defmodule Verdemind.BotanyFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Verdemind.Botany` context.
  """

  @doc """
  Generate a plant.
  """
  def plant_fixture(attrs \\ %{}) do
    {:ok, plant} =
      attrs
      |> Enum.into(%{
        common_pests: "some common_pests",
        environment: "some environment",
        growth_season: "some growth_season",
        harvesting: "some harvesting",
        height: "some height",
        how_to_plant: "some how_to_plant",
        how_to_water: "some how_to_water",
        is_this_a_plant: 42,
        light_requirements: "some light_requirements",
        location: "some location",
        name: "some name",
        native_to: "some native_to",
        plant_type: "some plant_type",
        proliferation: "some proliferation",
        scientific_name: "some scientific_name",
        soil: "some soil",
        symbiosis_with: "some symbiosis_with",
        uses: "some uses",
        watering_frequency: "some watering_frequency"
      })
      |> Verdemind.Botany.create_plant()

    plant
  end
end
