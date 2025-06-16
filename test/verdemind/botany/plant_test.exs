defmodule Verdemind.Botany.PlantTest do
  use Verdemind.DataCase, async: true

  alias Verdemind.Botany.Plant

  describe "changeset/2" do
    test "name is required" do
      changeset = Plant.changeset(%Plant{}, %{name: ""})
      assert %Ecto.Changeset{} = changeset
      assert changeset.valid? == false
      assert %{name: ["can't be blank"]} = errors_on(changeset)
    end
  end

  describe "InstructorLite.Instruction implementation" do
    test "notes/0 returns expected content" do
      notes = Plant.notes()

      assert is_binary(notes)
      assert String.contains?(notes, "Field Descriptions:")
      assert String.contains?(notes, "name:")
      assert String.contains?(notes, "is_it_a_plant:")
    end

    test "implements notes/0" do
      assert Verdemind.Botany.Plant.__info__(:functions) |> Keyword.get(:notes) != nil
    end
  end
end
