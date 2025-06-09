defmodule Verdemind.InstructorQuery do
  @moduledoc """
  Gets structural output from OpenAI using the Ecto Schema.
  Implements a behavior to allow mocking with Mox during testing.
  """
  @callback instruct(InstructorLite.Adapter.params(), InstructorLite.opts()) ::
              {:ok, Ecto.Schema.t()}
              | {:error, Ecto.Changeset.t()}
              | {:error, any()}
              | {:error, atom(), any()}

  @openai_default_system_prompt """
  You are a helpful and knowledgeable assistant.
  Your job is to provide clear, concise, and accurate information.

  The API receives a structured schema and you must format your responses to accurately follow this schema.
  Ensure that each field is filled with correct and useful data.
  If a field cannot be confidently completed,
  indicate that the information is unavailable. Do not guess.
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
         is_this_a_plant: 100,
         ...
       }}


  """
  @spec ask(String.t(), module(), String.t()) :: {:ok, Ecto.Schema.t()} | map()
  def ask(content, response_model, system_prompt \\ @openai_default_system_prompt) do
    instruct(
      %{
        messages: [%{role: "user", content: content}, %{role: "system", content: system_prompt}]
      },
      response_model: response_model,
      adapter: InstructorLite.Adapters.OpenAI,
      adapter_context: [api_key: openai_key()]
    )
    |> handle_result()
  end

  @spec instruct(InstructorLite.Adapter.params(), InstructorLite.opts()) ::
          {:ok, Ecto.Schema.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, any()}
          | {:error, atom(), any()}
  def instruct(params, opts) do
    impl().instruct(params, opts)
  end

  # :instructor_mock only set for testing, cf. test_helpers.exs
  defp impl, do: Application.get_env(:verdemind, :instructor_mock, InstructorLite)

  defp openai_key do
    case System.fetch_env("OPENAI_KEY") do
      {:ok, openai_key} -> openai_key
      _ -> "TEST_WITHOUT_OPENAI_KEY"
    end
  end

  defp handle_result(result) do
    case result do
      {:ok, plant} -> %{msg: :ok, plant: plant}
      {:error, reason} -> reason |> handle_error()
    end
  end

  defp handle_error(reason) do
    cond do
      reason |> is_struct() ->
        cond do
          reason |> is_map_key(:body) -> %{msg: :missing_openai_key, reason: reason}
          reason |> is_map_key(:reason) -> %{msg: :connection_error, reason: reason}
          reason -> %{msg: :other_error, reason: reason}
        end

      reason ->
        %{msg: :other_error, reason: reason}
    end
  end
end
