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

    test "create plant button renders plant", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/generate-plant")

      assert view
             |> element("button", "create Rosemary")
             |> render_click() =~ "%Verdemind.Botany.Plant{"
    end
  end

end
