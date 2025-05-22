defmodule Verdemind.InstructorQueryTest do
  use ExUnit.Case

  alias Verdemind.InstructorQuery
  alias Verdemind.Botany.Plant

  describe "ask/2" do
    test "Resturns the given ecto schema (note: OPENAI_KEY must be set in the bash `export OPENAI_KEY=\"Ru42...\" before testing)" do
      content = "Rosemary"
      response_model = Plant

      {:ok, %Plant{} = plant} = InstructorQuery.ask(content, response_model)
      %Plant{name: name} = plant
      assert name == "Rosemary"
    end
  end
end
