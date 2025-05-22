defmodule Verdemind.InstructorQuery do
  @moduledoc """
  Gets structural output from OpenAI using the Ecto Scheme.
  """

  @doc """
  Gets a structural response for `content` to fit in the Ecto schema, given with `response_model`.

  See the Ecto schema's `@notes` for finetuning the prompt.

  ## Example

      iex> Verdemind.InstructorQuery.ask("Rosemary", Verdemind.Botany.Plant)
      {:ok,
       %Verdemind.Botany.Plant{
         __meta__: #Ecto.Schema.Metadata<:built, "plants">,
         id: 1,
         name: "Rosemary",
         location: "Mediterranean regions, commonly grown in gardens and pots worldwide",
         uses: "Culinary (used in cooking meats and stews, flavoring for breads) and medicinal (supports digestion, memory enhancement)",
         scientific_name: "Rosmarinus officinalis",
         native_to: "Mediterranean region",
         plant_type: "Herb",
         environment: "Well-drained soil, moderate to dry conditions",
         light_requirements: "Full sun",
         soil: "Well-drained, sandy or loamy soil",
         height: "30 to 90",
         growth_season: "Primarily spring and summer",
         harvesting: "Harvest leaves as needed; for best flavor, cut stems before flowering.",
         how_to_plant: "Plant seeds or cuttings 1 cm deep, spaced 60 cm apart.",
         how_to_water: "Water thoroughly but allow soil to dry between watering to prevent root rot.",
         watering_frequency: "Every 1-2 weeks, depending on soil moisture",
         proliferation: "Seeds or cuttings",
         symbiosis_with: "Thyme, sage, and lavender",
         common_pests: "Spider mites, aphids, and root rot",
         is_this_a_plant: 100,
         inserted_at: ~U[2023-10-01 00:00:00Z],
         updated_at: ~U[2023-10-01 00:00:00Z]
       }}


  """
  @spec ask(any(), any()) ::
          {:error, any()} | {:ok, %{optional(atom()) => any()}} | {:error, atom(), any()}
  def ask(content, response_model) do
    InstructorLite.instruct(%{messages: [%{role: "user", content: content}]},
      response_model: response_model,
      adapter_context: [api_key: System.fetch_env!("OPENAI_KEY")]
    )
  end
end
