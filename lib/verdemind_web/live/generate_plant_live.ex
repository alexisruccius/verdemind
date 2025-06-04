defmodule VerdemindWeb.GeneratePlantLive do
  use VerdemindWeb, :live_view

  alias Phoenix.LiveView.AsyncResult
  alias Verdemind.Botany
  alias Verdemind.Botany.GeneratePlant

  import VerdemindWeb.MyComponents

  def render(assigns) do
    ~H"""
    <h1 class="text-lg font-bold py-4">Generate Plant</h1>
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

  def handle_event("validate", params, socket) do
    %{"generate_plant" => generate_plant_params} = params

    form = validate_form(generate_plant_params)

    {:noreply, socket |> assign(form: form)}
  end

  def handle_event("generate-plant", params, socket) do
    %{"generate_plant" => generate_plant_params} = params
    form = validate_form(generate_plant_params)

    case form.source.valid? do
      true ->
        %{"name" => name} = generate_plant_params

        {:noreply,
         socket
         |> assign_async(
           :plant,
           fn -> {:ok, %{plant: Botany.plant_from_instructor(name)}} end,
           reset: true
         )}

      false ->
        {:noreply, socket |> assign(form: form)}
    end
  end

  defp validate_form(params) do
    %GeneratePlant{}
    |> Botany.change_gererate_plant(params)
    |> to_form(action: :validate)
  end
end
