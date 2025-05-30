defmodule VerdemindWeb.GeneratePlantLive do
  use VerdemindWeb, :live_view

  alias Phoenix.LiveView.AsyncResult
  alias Verdemind.InstructorQuery
  alias Verdemind.Botany
  alias Verdemind.Botany.Plant
  alias Verdemind.Botany.GeneratePlant

  def render(assigns) do
    ~H"""
    <h1 class="text-lg py-4">Generate Plant</h1>
    <.form id="generate-plant-form" for={@form} phx-change="validate" phx-submit="generate-plant">
      <.input type="text" field={@form[:name]} placeholder="Rosemary" autofocus />
      <.submit_button form={@form} message="generate plant" />
    </.form>
    <.plant_async plant={@plant} />
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       plant: %AsyncResult{},
       form: to_form(Botany.change_gererate_plant(%GeneratePlant{}))
     )}
  end

  def handle_event("generate-plant", params, socket) do
    %{"generate_plant" => %{"name" => name}} = params

    {:noreply,
     socket
     |> assign_async(:plant, fn -> {:ok, %{plant: plant_from_instructor(name)}} end, reset: true)}
  end

  def handle_event("validate", params, socket) do
    %{"generate_plant" => generate_plant_params} = params

    form =
      %GeneratePlant{}
      |> Botany.change_gererate_plant(generate_plant_params)
      |> to_form(action: :validate)

    {:noreply, socket |> assign(form: form)}
  end

  defp plant_from_instructor(name) do
    {:ok, plant} = InstructorQuery.ask(name, Plant)
    plant
  end

  # components ->

  attr :plant, AsyncResult, required: true

  def plant_async(assigns) do
    ~H"""
    <dev>
      <.loading item_async={@plant} message="asking ChatGPT..." />
      <dev :if={@plant.ok?} class="p-2">
        <.plant_table plant={@plant} />
      </dev>
    </dev>
    """
  end

  attr :item_async, AsyncResult, required: true
  attr :message, :string, default: "loading..."

  def loading(assigns) do
    ~H"""
    <dev>
      <dev :if={@item_async.loading} class="flex flex-row justify-start">
        <dev class="px-2 pt-1">
          <span class="relative flex size-3">
            <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-lime-400 opacity-75">
            </span>
            <span class="relative inline-flex size-3 rounded-full bg-lime-500"></span>
          </span>
        </dev>
        <dev>{@message}</dev>
      </dev>
    </dev>
    """
  end

  attr :form, Phoenix.HTML.Form, required: true
  attr :message, :string, default: "submit"

  def submit_button(assigns) do
    ~H"""
    <dev>
      <button
        :if={@form.source.valid?}
        class="bg-lime-600 hover:bg-lime-700 text-white font-bold py-2 px-4 my-4 rounded"
      >
        {@message}
      </button>
      <button
        :if={not @form.source.valid?}
        class="bg-stone-400 text-white blur-[1px] font-bold py-2 px-4 my-4 rounded"
        type="button"
        disabled
      >
        {@message}
      </button>
    </dev>
    """
  end

  attr :plant, AsyncResult, required: true

  def plant_table(assigns) do
    ~H"""
    <dev>
      <.list>
        <:item title="Name">{@plant.result.name}</:item>
        <:item title="Scientific name">{@plant.result.scientific_name}</:item>
        <:item title="Location">{@plant.result.location}</:item>
        <:item title="Native to">{@plant.result.native_to}</:item>
        <:item title="Plant type">{@plant.result.plant_type}</:item>
        <:item title="Environment">{@plant.result.environment}</:item>
        <:item title="Light requirements">{@plant.result.light_requirements}</:item>
        <:item title="Soil">{@plant.result.soil}</:item>
        <:item title="Height">{@plant.result.height}</:item>
        <:item title="Growth season">{@plant.result.growth_season}</:item>
        <:item title="Harvesting">{@plant.result.harvesting}</:item>
        <:item title="How to plant">{@plant.result.how_to_plant}</:item>
        <:item title="How to water">{@plant.result.how_to_water}</:item>
        <:item title="Watering frequency">{@plant.result.watering_frequency}</:item>
        <:item title="Proliferation">{@plant.result.proliferation}</:item>
        <:item title="Symbiosis with">{@plant.result.symbiosis_with}</:item>
        <:item title="Uses">{@plant.result.uses}</:item>
        <:item title="Common pests">{@plant.result.common_pests}</:item>
        <:item title="Is this a plant">{@plant.result.is_this_a_plant}</:item>
      </.list>
    </dev>
    """
  end
end
