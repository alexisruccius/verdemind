defmodule VerdemindWeb.GeneratePlantLiveTest do
  use VerdemindWeb.ConnCase
  import Phoenix.LiveViewTest
  alias VerdemindWeb.GeneratePlantLive

  describe "LiveView GeneratePlantLive" do
    test "connected mount", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/generate-plant")
      assert view.module == GeneratePlantLive
    end

    test "title correct", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/generate-plant")
      assert html =~ ">Generate Plant</h1>"
    end

    test "form input field for plant name", %{conn: conn} do
      {:ok, _view, html} = live(conn, "/generate-plant")

      assert html =~ "<input"
      assert html =~ "name=\"name\""
    end

    test "submit plant name and show async loading message", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/generate-plant")

      result = view |> form("#plant-name-form", %{"name" => "Rosemary"}) |> render_submit()
      assert result =~ "asking ChatGPT..."

      async_result = view |> render_async(8000)
      assert async_result =~ ">Name</dt>"
      assert async_result =~ ">Rosemary</dd>"
    end
  end
end
