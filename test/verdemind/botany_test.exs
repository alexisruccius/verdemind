defmodule Verdemind.BotanyTest do
  use Verdemind.DataCase

  alias Verdemind.Botany

  describe "plants" do
    alias Verdemind.Botany.Plant
    alias Verdemind.Botany.GeneratePlant

    import Verdemind.BotanyFixtures

    @invalid_attrs %{
      name: nil,
      location: nil,
      uses: nil,
      scientific_name: nil,
      native_to: nil,
      plant_type: nil,
      environment: nil,
      light_requirements: nil,
      soil: nil,
      height: nil,
      growth_season: nil,
      harvesting: nil,
      how_to_plant: nil,
      how_to_water: nil,
      watering_frequency: nil,
      proliferation: nil,
      symbiosis_with: nil,
      common_pests: nil,
      is_this_a_plant: nil
    }

    test "list_plants/0 returns all plants" do
      plant = plant_fixture()
      assert Botany.list_plants() == [plant]
    end

    test "get_plant!/1 returns the plant with given id" do
      plant = plant_fixture()
      assert Botany.get_plant!(plant.id) == plant
    end

    test "create_plant/1 with valid data creates a plant" do
      valid_attrs = %{
        name: "some name",
        location: "some location",
        uses: "some uses",
        scientific_name: "some scientific_name",
        native_to: "some native_to",
        plant_type: "some plant_type",
        environment: "some environment",
        light_requirements: "some light_requirements",
        soil: "some soil",
        height: "some height",
        growth_season: "some growth_season",
        harvesting: "some harvesting",
        how_to_plant: "some how_to_plant",
        how_to_water: "some how_to_water",
        watering_frequency: "some watering_frequency",
        proliferation: "some proliferation",
        symbiosis_with: "some symbiosis_with",
        common_pests: "some common_pests",
        is_this_a_plant: 42
      }

      assert {:ok, %Plant{} = plant} = Botany.create_plant(valid_attrs)
      assert plant.name == "some name"
      assert plant.location == "some location"
      assert plant.uses == "some uses"
      assert plant.scientific_name == "some scientific_name"
      assert plant.native_to == "some native_to"
      assert plant.plant_type == "some plant_type"
      assert plant.environment == "some environment"
      assert plant.light_requirements == "some light_requirements"
      assert plant.soil == "some soil"
      assert plant.height == "some height"
      assert plant.growth_season == "some growth_season"
      assert plant.harvesting == "some harvesting"
      assert plant.how_to_plant == "some how_to_plant"
      assert plant.how_to_water == "some how_to_water"
      assert plant.watering_frequency == "some watering_frequency"
      assert plant.proliferation == "some proliferation"
      assert plant.symbiosis_with == "some symbiosis_with"
      assert plant.common_pests == "some common_pests"
      assert plant.is_this_a_plant == 42
    end

    test "create_plant/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Botany.create_plant(@invalid_attrs)
    end

    test "update_plant/2 with valid data updates the plant" do
      plant = plant_fixture()

      update_attrs = %{
        name: "some updated name",
        location: "some updated location",
        uses: "some updated uses",
        scientific_name: "some updated scientific_name",
        native_to: "some updated native_to",
        plant_type: "some updated plant_type",
        environment: "some updated environment",
        light_requirements: "some updated light_requirements",
        soil: "some updated soil",
        height: "some updated height",
        growth_season: "some updated growth_season",
        harvesting: "some updated harvesting",
        how_to_plant: "some updated how_to_plant",
        how_to_water: "some updated how_to_water",
        watering_frequency: "some updated watering_frequency",
        proliferation: "some updated proliferation",
        symbiosis_with: "some updated symbiosis_with",
        common_pests: "some updated common_pests",
        is_this_a_plant: 43
      }

      assert {:ok, %Plant{} = plant} = Botany.update_plant(plant, update_attrs)
      assert plant.name == "some updated name"
      assert plant.location == "some updated location"
      assert plant.uses == "some updated uses"
      assert plant.scientific_name == "some updated scientific_name"
      assert plant.native_to == "some updated native_to"
      assert plant.plant_type == "some updated plant_type"
      assert plant.environment == "some updated environment"
      assert plant.light_requirements == "some updated light_requirements"
      assert plant.soil == "some updated soil"
      assert plant.height == "some updated height"
      assert plant.growth_season == "some updated growth_season"
      assert plant.harvesting == "some updated harvesting"
      assert plant.how_to_plant == "some updated how_to_plant"
      assert plant.how_to_water == "some updated how_to_water"
      assert plant.watering_frequency == "some updated watering_frequency"
      assert plant.proliferation == "some updated proliferation"
      assert plant.symbiosis_with == "some updated symbiosis_with"
      assert plant.common_pests == "some updated common_pests"
      assert plant.is_this_a_plant == 43
    end

    test "update_plant/2 with invalid data returns error changeset" do
      plant = plant_fixture()
      assert {:error, %Ecto.Changeset{}} = Botany.update_plant(plant, @invalid_attrs)
      assert plant == Botany.get_plant!(plant.id)
    end

    test "delete_plant/1 deletes the plant" do
      plant = plant_fixture()
      assert {:ok, %Plant{}} = Botany.delete_plant(plant)
      assert_raise Ecto.NoResultsError, fn -> Botany.get_plant!(plant.id) end
    end

    test "change_plant/1 returns a plant changeset" do
      plant = plant_fixture()
      assert %Ecto.Changeset{} = Botany.change_plant(plant)
    end

    test "change_generate_plant/1 returns a generate_plant changeset" do
      generate_plant = %GeneratePlant{}
      assert %Ecto.Changeset{} = Botany.change_gererate_plant(generate_plant)
    end
  end
end
