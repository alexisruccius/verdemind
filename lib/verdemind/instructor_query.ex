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
  @spec ask(String.t(), module()) ::
          {:ok, Ecto.Schema.t()}
          | {:error, Ecto.Changeset.t()}
          | {:error, any()}
          | {:error, atom(), any()}
  def ask(content, response_model) do
    instruct(
      %{messages: [%{role: "user", content: content}]},
      response_model: response_model,
      adapter: InstructorLite.Adapters.OpenAI,
      adapter_context: [api_key: System.fetch_env!("OPENAI_KEY")]
    )
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
end
