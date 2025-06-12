defmodule Verdemind.Botany.Plant do
  use Ecto.Schema
  import Ecto.Changeset

  use InstructorLite.Instruction

  @openai_plant_system_prompt """
  You are a helpful and knowledgeable assistant in a plant identification and care app.
  Your job is to provide clear, concise, and accurate information about plants
  based on the name the user enters.
  When a user provides the name of a plant, respond with relevant information.

  The API receives a structured schema and you must format your responses to accurately follow this schema.
  Ensure that each field is filled with correct and useful data.
  If a field cannot be confidently completed,
  indicate that the information is unavailable. Do not guess.

  If the plant name is unclear or ambiguous, ask the user to clarify.
  In this case, put the clarification request in the name field of the structured response,
  additionally, suggest up to 3 possible plant names the user might have meant, based on the input,
  and populate other fields with N/A.
  Keep your tone friendly, beginner-friendly, and informative.

  If the user asks about the plant's height,
  always answer using the metric system (centimeters or meters),
  depending on the typical size of the plant.

  If the user asks whether the input is a plant, respond with a percentage (from 0 to 100)
  indicating how likely it is that the input refers to a plant.
  Base this on your confidence and available data,
  and explain your reasoning briefly if appropriate.

  If the structured schema includes inserted_at or updated_at fields,
  insert the current UTC datetime in ISO 8601 format (e.g. 2025-06-09T14:30:00Z).
  """

  @notes """
  Field Descriptions:
  - name: The common name of the plant.
  - location: Where the plant is commonly grown or found.
  - uses: Primary uses of the plant (e.g., medicinal, culinary, ornamental) with one or two examples.
  - scientific_name: The scientific (Latin) name of the plant.
  - native_to: Region or climate where the plant originates.
  - plant_type: Type of plant (e.g., herb, shrub, vine).
  - environment: Ideal growing conditions for the plant.
  - light_requirements: Sunlight requirements (e.g., full sun, partial shade).
  - soil: Preferred soil type (e.g., loamy, sandy, well-drained).
  - height: Enter the typical mature height of the plant (in centimeters).
  - growth_season: Seasons during which the plant grows or blooms.
  - harvesting: When and how to harvest the plant.
  - how_to_plant: Instructions for planting (e.g., seed depth, spacing).
  - how_to_water: Watering guidelines to maintain healthy growth.
  - watering_frequency: How often to water the plant.
  - proliferation: Methods of propagation (e.g., seeds, cuttings).
  - symbiosis_with: Companion plants that grow well with this one.
  - common_pests: Pests or diseases that commonly affect the plant.
  - is_it_a_plant: Returns a differentiated score from 0 to 100 indicating the likelihood that the subject is a real, physical botanical plant. A score of 100 means it is definitely a real, physical plant. A score of 0 means it does not exist as a physical entity (e.g., fictional, abstract, digital-only, or non-botanical).
  """
  schema "plants" do
    field :name, :string
    field :location, :string
    field :uses, :string
    field :scientific_name, :string
    field :native_to, :string
    field :plant_type, :string
    field :environment, :string
    field :light_requirements, :string
    field :soil, :string
    field :height, :string
    field :growth_season, :string
    field :harvesting, :string
    field :how_to_plant, :string
    field :how_to_water, :string
    field :watering_frequency, :string
    field :proliferation, :string
    field :symbiosis_with, :string
    field :common_pests, :string
    field :is_this_a_plant, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(plant, attrs) do
    plant
    |> cast(attrs, [
      :name,
      :scientific_name,
      :location,
      :native_to,
      :plant_type,
      :environment,
      :light_requirements,
      :soil,
      :height,
      :growth_season,
      :harvesting,
      :how_to_plant,
      :how_to_water,
      :watering_frequency,
      :proliferation,
      :symbiosis_with,
      :uses,
      :common_pests,
      :is_this_a_plant
    ])
    |> validate_required([
      :name,
      :scientific_name,
      :location,
      :native_to,
      :plant_type,
      :environment,
      :light_requirements,
      :soil,
      :height,
      :growth_season,
      :harvesting,
      :how_to_plant,
      :how_to_water,
      :watering_frequency,
      :proliferation,
      :symbiosis_with,
      :uses,
      :common_pests,
      :is_this_a_plant
    ])
    |> validate_number(:is_this_a_plant,
      greater_than: 95,
      message:
        "Hmm, this might not be a plant. Please generate a new plant or set the confidence above 95."
    )
  end

  def openai_plant_system_prompt(), do: @openai_plant_system_prompt
end
