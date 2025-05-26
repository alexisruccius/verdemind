defmodule VerdemindWeb.GeneratePlantLive do
  use VerdemindWeb, :live_view

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
      <dev>
        {@plant |> inspect()}
      </dev>
    </dev>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, :plant, "")}
  end

  def handle_event("create_plant", params, socket) do
    %{"name" => name} = params
    IO.inspect(params)
    {:ok, plant} = InstructorQuery.ask(name, Plant)
    {:noreply, socket |> assign(:plant, plant)}
  end
end
