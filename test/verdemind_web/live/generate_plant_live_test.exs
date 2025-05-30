defmodule VerdemindWeb.GeneratePlantLiveTest do
  use VerdemindWeb.ConnCase
  import Phoenix.LiveViewTest
  alias VerdemindWeb.GeneratePlantLive

  describe "LiveView GeneratePlantLive" do
    test "connected mount", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")
      assert view.module == GeneratePlantLive
    end

    test "title correct", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/generate-plant")
      assert html =~ ">Generate Plant</h1>"
    end

    test "form input field for generate_plant name", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/generate-plant")

      assert html =~ "<input"
      assert html =~ "name=\"generate_plant[name]\""
    end

    test "submit plant name and show async loading message", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view
        |> form("#generate-plant-form", generate_plant: %{"name" => "Rosemary"})
        |> render_submit()

      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(8000)
      assert async_result =~ ">Name</dt>"
      assert async_result =~ ">Rosemary</dd>"
    end

    test "generate plant form renders errors if empty plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view |> form("#generate-plant-form", generate_plant: %{"name" => ""}) |> render_change()

      assert result =~ "can&#39;t be blank"
    end

    test "generate plant form renders errors if too short plant name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/generate-plant")

      result =
        view |> form("#generate-plant-form", generate_plant: %{"name" => "Ro"}) |> render_change()

      assert result =~ "should be at least 3 character(s)"
    end
  end
end
