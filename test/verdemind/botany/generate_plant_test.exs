defmodule Verdemind.Botany.GeneratePlantTest do
  use Verdemind.DataCase, async: true

  alias Verdemind.Botany.GeneratePlant

  describe "changeset/2" do
    test "name is required" do
      changeset = GeneratePlant.changeset(%GeneratePlant{}, %{name: ""})
      assert %Ecto.Changeset{} = changeset
      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end

    test "name must be at least 3 characters long" do
      changeset = GeneratePlant.changeset(%GeneratePlant{}, %{name: "Na"})
      assert changeset.valid? == false
      assert %{name: ["should be at least 3 character(s)"]} = errors_on(changeset)
    end

    test "valid changeset with name" do
      changeset = GeneratePlant.changeset(%GeneratePlant{}, %{name: "Rose"})
      assert changeset.valid?
      assert %{name: "Rose"} = changeset.changes
    end

    test "ignores not permitted fields" do
      changeset = GeneratePlant.changeset(%GeneratePlant{}, %{name: "Rose", color: "yellow"})

      assert changeset.valid?
      assert changeset.changes |> Map.has_key?(:name)
      refute changeset.changes |> Map.has_key?(:color)
    end
  end

  describe "changeset/1" do
    test "default params (empty map)" do
      changeset = GeneratePlant.changeset(%GeneratePlant{})
      assert %Ecto.Changeset{} = changeset
      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end
end
