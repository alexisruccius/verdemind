defmodule VerdemindWeb.MyComponents do
  use Phoenix.Component
  alias Phoenix.LiveView.AsyncResult

  @doc """
  Renders a table displaying data for a single Plant, fetched asynchronously.
  Shows a loading message while fetching.
  """
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

  @doc """
  Shows a loading message while fetching data asynchronously.
  """
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

  @doc """
  Renders a submit button that is disabled when the form data is invalid.
  """
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

  @doc """
  Renders a table displaying the details of a single Plant.
  """
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

  @doc """
  Renders a data list.
  """
  slot :item, required: true do
    attr :title, :string, required: true
  end

  def list(assigns) do
    ~H"""
    <div class="mt-14">
      <dl class="-my-4 divide-y divide-stone-400">
        <div :for={item <- @item} class="flex gap-4 py-4 text-sm leading-6 sm:gap-8">
          <dt class="w-1/4 flex-none text-stone-300">{item.title}</dt>
          <dd class="text-white">{render_slot(item)}</dd>
        </div>
      </dl>
    </div>
    """
  end
end
