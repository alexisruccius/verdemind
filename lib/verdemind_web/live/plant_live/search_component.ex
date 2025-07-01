defmodule VerdemindWeb.PlantLive.SearchComponent do
  alias Verdemind.Botany.SearchPlant
  use VerdemindWeb, :live_component

  alias Verdemind.Botany

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        for={@form}
        id="plant-search"
        phx-target={@myself}
        phx-change="search"
        phx-submit="search"
      >
        <.input field={@form[:query]} type="text" placeholder="search plants" />
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(_assigns, socket) do
    all_plants = Botany.list_plants()

    {:ok,
     socket
     |> assign(all_plants: all_plants)
     |> assign_new(:form, fn -> %SearchPlant{} |> Botany.change_search_plant() |> to_form() end)}
  end

  @impl true
  def handle_event("search", %{"search_plant" => search_plant_params}, socket) do
    %{"query" => query} = search_plant_params
    socket |> filter_plants(query) |> update_parent()
    {:noreply, socket}
  end

  defp filter_plants(socket, query) do
    all_plants = socket.assigns.all_plants

    all_plants
    |> Enum.filter(fn p ->
      String.contains?(p.name |> String.upcase(), query |> String.upcase())
    end)
  end

  defp update_parent(filtered_plants) do
    send(self(), {:filtered_plants, filtered_plants})
  end
end
