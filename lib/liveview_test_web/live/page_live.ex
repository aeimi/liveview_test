defmodule LiveviewTestWeb.PageLive do
  use LiveviewTestWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(continent_options: ["Europe", "Asia"])
      |> assign(country_options: [])

    {:ok, socket}
  end

  @impl true
  def handle_event("form_changed", %{"form" => form_params}, socket) do
    %{
      "continent" => continent
    } = form_params

    countries =
      case continent do
        "Europe" -> ["Germany", "France", "Spain"]
        "Asia" -> ["Japan", "China", "India"]
        "" -> []
      end

    socket =
      socket
      |> assign(country_options: countries)

    {:noreply, socket}
  end
end
