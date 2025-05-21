defmodule VerdemindWeb.PlantLiveTest do
  use VerdemindWeb.ConnCase

  import Phoenix.LiveViewTest
  import Verdemind.BotanyFixtures

  @create_attrs %{name: "some name", location: "some location", uses: "some uses", scientific_name: "some scientific_name", native_to: "some native_to", plant_type: "some plant_type", environment: "some environment", light_requirements: "some light_requirements", soil: "some soil", height: "some height", growth_season: "some growth_season", harvesting: "some harvesting", how_to_plant: "some how_to_plant", how_to_water: "some how_to_water", watering_frequency: "some watering_frequency", proliferation: "some proliferation", symbiosis_with: "some symbiosis_with", common_pests: "some common_pests", is_this_a_plant: 42}
  @update_attrs %{name: "some updated name", location: "some updated location", uses: "some updated uses", scientific_name: "some updated scientific_name", native_to: "some updated native_to", plant_type: "some updated plant_type", environment: "some updated environment", light_requirements: "some updated light_requirements", soil: "some updated soil", height: "some updated height", growth_season: "some updated growth_season", harvesting: "some updated harvesting", how_to_plant: "some updated how_to_plant", how_to_water: "some updated how_to_water", watering_frequency: "some updated watering_frequency", proliferation: "some updated proliferation", symbiosis_with: "some updated symbiosis_with", common_pests: "some updated common_pests", is_this_a_plant: 43}
  @invalid_attrs %{name: nil, location: nil, uses: nil, scientific_name: nil, native_to: nil, plant_type: nil, environment: nil, light_requirements: nil, soil: nil, height: nil, growth_season: nil, harvesting: nil, how_to_plant: nil, how_to_water: nil, watering_frequency: nil, proliferation: nil, symbiosis_with: nil, common_pests: nil, is_this_a_plant: nil}

  defp create_plant(_) do
    plant = plant_fixture()
    %{plant: plant}
  end

  describe "Index" do
    setup [:create_plant]

    test "lists all plants", %{conn: conn, plant: plant} do
      {:ok, _index_live, html} = live(conn, ~p"/plants")

      assert html =~ "Listing Plants"
      assert html =~ plant.name
    end

    test "saves new plant", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/plants")

      assert index_live |> element("a", "New Plant") |> render_click() =~
               "New Plant"

      assert_patch(index_live, ~p"/plants/new")

      assert index_live
             |> form("#plant-form", plant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#plant-form", plant: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plants")

      html = render(index_live)
      assert html =~ "Plant created successfully"
      assert html =~ "some name"
    end

    test "updates plant in listing", %{conn: conn, plant: plant} do
      {:ok, index_live, _html} = live(conn, ~p"/plants")

      assert index_live |> element("#plants-#{plant.id} a", "Edit") |> render_click() =~
               "Edit Plant"

      assert_patch(index_live, ~p"/plants/#{plant}/edit")

      assert index_live
             |> form("#plant-form", plant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#plant-form", plant: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/plants")

      html = render(index_live)
      assert html =~ "Plant updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes plant in listing", %{conn: conn, plant: plant} do
      {:ok, index_live, _html} = live(conn, ~p"/plants")

      assert index_live |> element("#plants-#{plant.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#plants-#{plant.id}")
    end
  end

  describe "Show" do
    setup [:create_plant]

    test "displays plant", %{conn: conn, plant: plant} do
      {:ok, _show_live, html} = live(conn, ~p"/plants/#{plant}")

      assert html =~ "Show Plant"
      assert html =~ plant.name
    end

    test "updates plant within modal", %{conn: conn, plant: plant} do
      {:ok, show_live, _html} = live(conn, ~p"/plants/#{plant}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Plant"

      assert_patch(show_live, ~p"/plants/#{plant}/show/edit")

      assert show_live
             |> form("#plant-form", plant: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#plant-form", plant: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/plants/#{plant}")

      html = render(show_live)
      assert html =~ "Plant updated successfully"
      assert html =~ "some updated name"
    end
  end
end
