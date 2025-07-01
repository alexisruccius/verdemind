defmodule Verdemind.Botany.SearchPlantTest do
  use Verdemind.DataCase, async: true

  alias Verdemind.Botany.SearchPlant

  describe "changeset/2" do
    test "changeset with query" do
      changeset = SearchPlant.changeset(%SearchPlant{}, %{query: "Rose"})
      assert changeset.valid?
      assert %{query: "Rose"} = changeset.changes
    end

    test "ignores not permitted fields" do
      changeset = SearchPlant.changeset(%SearchPlant{}, %{query: "Rose", color: "yellow"})

      assert changeset.valid?
      assert changeset.changes |> Map.has_key?(:query)
      refute changeset.changes |> Map.has_key?(:color)
    end
  end

  describe "changeset/1" do
    test "default params (empty map)" do
      changeset = SearchPlant.changeset(%SearchPlant{})
      assert %Ecto.Changeset{} = changeset
      assert changeset.valid? == true
    end
  end
end
