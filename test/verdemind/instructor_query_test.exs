defmodule Verdemind.InstructorQueryTest do
  use ExUnit.Case, async: true

  alias Verdemind.InstructorQuery
  alias Verdemind.Botany.Plant

  import Mox

  # Mox: make sure mocks are verified when the test exits
  setup :verify_on_exit!

  describe "ask/2" do
    test "Resturns the given ecto schema (note: OPENAI_KEY must be set in the bash `export OPENAI_KEY=\"Ru42...\" before testing)" do
      # Mox
      Verdemind.MockInstructorQuery
      |> expect(
        :instruct,
        fn %{messages: messages}, _opts ->
          [%{content: content}] = messages
          {:ok, %Plant{} |> struct!(name: content)}
        end
      )

      content = "Rosemary"
      response_model = Plant

      {:ok, %Plant{} = plant} = InstructorQuery.ask(content, response_model)
      %Plant{name: name} = plant
      assert name == "Rosemary"
    end
  end
end
