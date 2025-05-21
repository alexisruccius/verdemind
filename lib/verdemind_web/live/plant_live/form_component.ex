defmodule VerdemindWeb.PlantLive.FormComponent do
  use VerdemindWeb, :live_component

  alias Verdemind.Botany

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage plant records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="plant-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:scientific_name]} type="text" label="Scientific name" />
        <.input field={@form[:location]} type="text" label="Location" />
        <.input field={@form[:native_to]} type="text" label="Native to" />
        <.input field={@form[:plant_type]} type="text" label="Plant type" />
        <.input field={@form[:environment]} type="text" label="Environment" />
        <.input field={@form[:light_requirements]} type="text" label="Light requirements" />
        <.input field={@form[:soil]} type="text" label="Soil" />
        <.input field={@form[:height]} type="text" label="Height" />
        <.input field={@form[:growth_season]} type="text" label="Growth season" />
        <.input field={@form[:harvesting]} type="text" label="Harvesting" />
        <.input field={@form[:how_to_plant]} type="text" label="How to plant" />
        <.input field={@form[:how_to_water]} type="text" label="How to water" />
        <.input field={@form[:watering_frequency]} type="text" label="Watering frequency" />
        <.input field={@form[:proliferation]} type="text" label="Proliferation" />
        <.input field={@form[:symbiosis_with]} type="text" label="Symbiosis with" />
        <.input field={@form[:uses]} type="text" label="Uses" />
        <.input field={@form[:common_pests]} type="text" label="Common pests" />
        <.input field={@form[:is_this_a_plant]} type="number" label="Is this a plant" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Plant</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{plant: plant} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Botany.change_plant(plant))
     end)}
  end

  @impl true
  def handle_event("validate", %{"plant" => plant_params}, socket) do
    changeset = Botany.change_plant(socket.assigns.plant, plant_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"plant" => plant_params}, socket) do
    save_plant(socket, socket.assigns.action, plant_params)
  end

  defp save_plant(socket, :edit, plant_params) do
    case Botany.update_plant(socket.assigns.plant, plant_params) do
      {:ok, plant} ->
        notify_parent({:saved, plant})

        {:noreply,
         socket
         |> put_flash(:info, "Plant updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_plant(socket, :new, plant_params) do
    case Botany.create_plant(plant_params) do
      {:ok, plant} ->
        notify_parent({:saved, plant})

        {:noreply,
         socket
         |> put_flash(:info, "Plant created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
