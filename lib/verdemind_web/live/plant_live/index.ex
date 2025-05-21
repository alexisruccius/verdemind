defmodule VerdemindWeb.PlantLive.Index do
  use VerdemindWeb, :live_view

  alias Verdemind.Botany
  alias Verdemind.Botany.Plant

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :plants, Botany.list_plants())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Plant")
    |> assign(:plant, Botany.get_plant!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Plant")
    |> assign(:plant, %Plant{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Plants")
    |> assign(:plant, nil)
  end

  @impl true
  def handle_info({VerdemindWeb.PlantLive.FormComponent, {:saved, plant}}, socket) do
    {:noreply, stream_insert(socket, :plants, plant)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    plant = Botany.get_plant!(id)
    {:ok, _} = Botany.delete_plant(plant)

    {:noreply, stream_delete(socket, :plants, plant)}
  end
end
