defmodule VerdemindWeb.MyComponents do
  use Phoenix.Component
  alias Phoenix.LiveView.AsyncResult

  import VerdemindWeb.CoreComponents

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
      <dev :if={@item_async.loading} class="my-4 flex flex-row justify-start">
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
  attr :id, :string, default: "submit-button"

  def submit_button(assigns) do
    ~H"""
    <dev id={@id}>
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
  attr :class, :string, default: nil

  def plant_card(assigns) do
    ~H"""
    <div class={[
      "m-4 bg-stone-800",
      "border border-t-white border-b-stone-600 border-r-stone-400 border-l-stone-400",
      "rounded-2xl p-6 max-w-4xl mx-auto shadow-lg font-hand text-white text-[15px] leading-relaxed",
      @class
    ]}>
      <div class="flex flex-col md:flex-row gap-6">
        <div class="md:w-1/2 space-y-2">
          <h2 class="text-2xl font-bold uppercase tracking-widest text-lime-400 flex items-center gap-2">
            <.icon name="hero-cog-6-tooth" class="w-6 h-6 text-lime-400" />
            {@plant.name}
          </h2>
          <p class="italic">{@plant.scientific_name}</p>
          <p>
            <.icon name="hero-globe-alt" class="w-4 h-4 text-lime-300" />
            <span class="font-bold text-lime-300">Environment:</span> {@plant.environment}
          </p>
          <p>
            <.icon name="hero-tag" class="w-4 h-4 text-yellow-200" />
            <span class="font-bold text-yellow-200">
              Type:
            </span>
            {@plant.plant_type}
          </p>
          <p>
            <.icon name="hero-map" class="w-4 h-4 text-amber-300" />
            <span class="font-bold text-amber-300">
              Native To:
            </span>
            {@plant.native_to}
          </p>
          <p>
            <.icon name="hero-map" class="w-4 h-4 text-amber-300" />
            <span class="font-bold text-amber-300">
              Location:
            </span>
            {@plant.location}
          </p>
          <p>
            <.icon name="hero-sun" class="w-4 h-4 text-amber-500" />
            <span class="font-bold text-amber-500">Light:</span> {@plant.light_requirements}
          </p>
          <p>
            <.icon name="hero-beaker text-orange-500" class="w-4 h-4" />
            <span class="font-bold text-orange-500">Soil:</span> {@plant.soil}
          </p>
          <p>
            <.icon name="hero-arrows-up-down text-rose-500" class="w-4 h-4" />
            <span class="font-bold text-rose-500">Height:</span> {@plant.height}
          </p>
        </div>
        <div class="md:w-1/2 space-y-2">
          <p>
            <.icon name="hero-calendar" class="w-4 h-4 text-rose-400" />
            <span class="font-bold text-rose-400">Growth Season:</span> {@plant.growth_season}
          </p>
          <p>
            <.icon name="hero-scissors" class="w-4 h-4 text-pink-400" />
            <span class="font-bold text-pink-400">Harvesting:</span>
            {@plant.harvesting}
          </p>
          <p>
            <.icon name="hero-briefcase" class="w-4 h-4 text-fuchsia-400" />
            <span class="font-bold text-fuchsia-400">Uses:</span>
            {@plant.uses}
          </p>
          <p>
            <.icon name="hero-cloud" class="w-4 h-4 text-sky-400" />
            <span class="font-bold text-sky-400">Water:</span>
            {@plant.how_to_water} ({@plant.watering_frequency})
          </p>
          <p>
            <.icon name="hero-arrow-path" class="w-4 h-4 text-teal-400" />
            <span class="font-bold text-teal-400">
              Proliferation:
            </span>
            {@plant.proliferation}
          </p>
          <p>
            <.icon name="hero-bug-ant" class="w-4 h-4 text-green-400" />
            <span class="font-bold text-green-400">
              Common Pests:
            </span>
            {@plant.common_pests}
          </p>
          <p>
            <.icon name="hero-link" class="w-4 h-4 text-lime-400" />
            <span class="font-bold text-lime-400">
              Symbiosis:
            </span>
            {@plant.symbiosis_with}
          </p>
        </div>
      </div>
    </div>
    """
  end
end
