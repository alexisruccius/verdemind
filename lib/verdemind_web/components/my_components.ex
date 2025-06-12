defmodule VerdemindWeb.MyComponents do
  use Phoenix.Component
  alias Phoenix.LiveView.AsyncResult

  @doc """
  Renders a table displaying data for a single Plant, fetched asynchronously.
  Shows a loading message while fetching.
  """
  attr :plant_async, AsyncResult, required: true
  slot :inner_block, required: true

  def plant_async(assigns) do
    ~H"""
    <dev>
      <.loading item_async={@plant_async} message="asking ChatGPT..." />
      <dev :if={@plant_async.ok?} class="p-2">
        <dev :if={@plant_async.result.msg == :ok}>
          {render_slot(@inner_block)}
        </dev>
        <dev :if={@plant_async.result.msg == :missing_openai_key}><.missing_openai_key /></dev>
        <dev :if={@plant_async.result.msg == :connection_error}>
          <.connection_error reason={@plant_async.result.reason} />
        </dev>
        <dev :if={@plant_async.result.msg == :other_error}>
          other_error: {inspect(@plant_async.result.reason)}
        </dev>
      </dev>
    </dev>
    """
  end

  defp missing_openai_key(assigns) do
    ~H"""
    <h3>**Missing OPENAI_KEY**</h3>
    <p>The `OPENAI_KEY` environment variable is not set.
      Please set it before starting the Phoenix server:</p>
    <p>export OPENAI_KEY="your_openai_key_here"</p>
    <p>mix phx.server</p>
    """
  end

  defp connection_error(assigns) do
    ~H"""
    <h3>**Connection Error**</h3>
    <p>Unable to connect to the OpenAI server or the internet.
      Please check your connection and try again.</p>
    <p class="text-xs">{inspect(@reason)}</p>
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
        phx-disable-with="..."
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
  attr :plant, :map, required: true

  def plant_table(assigns) do
    ~H"""
    <dev>
      <.list>
        <:item title="Name">{@plant.name}</:item>
        <:item title="Scientific name">{@plant.scientific_name}</:item>
        <:item title="Location">{@plant.location}</:item>
        <:item title="Native to">{@plant.native_to}</:item>
        <:item title="Plant type">{@plant.plant_type}</:item>
        <:item title="Environment">{@plant.environment}</:item>
        <:item title="Light requirements">{@plant.light_requirements}</:item>
        <:item title="Soil">{@plant.soil}</:item>
        <:item title="Height">{@plant.height}</:item>
        <:item title="Growth season">{@plant.growth_season}</:item>
        <:item title="Harvesting">{@plant.harvesting}</:item>
        <:item title="How to plant">{@plant.how_to_plant}</:item>
        <:item title="How to water">{@plant.how_to_water}</:item>
        <:item title="Watering frequency">{@plant.watering_frequency}</:item>
        <:item title="Proliferation">{@plant.proliferation}</:item>
        <:item title="Symbiosis with">{@plant.symbiosis_with}</:item>
        <:item title="Uses">{@plant.uses}</:item>
        <:item title="Common pests">{@plant.common_pests}</:item>
        <:item title="Is this a plant">{@plant.is_this_a_plant}</:item>
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
