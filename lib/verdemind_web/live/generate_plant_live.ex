defmodule VerdemindWeb.GeneratePlantLive do
  use VerdemindWeb, :live_view

  alias Phoenix.LiveView.AsyncResult
  alias Verdemind.InstructorQuery
  alias Verdemind.Botany.Plant

  def render(assigns) do
    ~H"""
    <h1 class="text-lg py-4">Generate Plant</h1>
    <dev class="grid">
      <button
        phx-click="create_plant"
        phx-value-name="Rosemary"
        class="bg-stone-500 hover:bg-stone-700 text-white font-bold py-2 px-4 my-4 rounded"
      >
        create Rosemary
      </button>
      <.plant_async plant={@plant} />
    </dev>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, plant: %AsyncResult{})}
  end

  def handle_event("create_plant", params, socket) do
    %{"name" => name} = params

    {:noreply,
     socket |> assign_async(:plant, fn -> {:ok, %{plant: plant_from_instructor(name)}} end)}
  end

  defp plant_from_instructor(name) do
    {:ok, plant} = InstructorQuery.ask(name, Plant)
    plant
  end

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
            <span class="absolute inline-flex h-full w-full animate-ping rounded-full bg-stone-400 opacity-75">
            </span>
            <span class="relative inline-flex size-3 rounded-full bg-stone-500"></span>
          </span>
        </dev>
        <dev>{@message}</dev>
      </dev>
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
