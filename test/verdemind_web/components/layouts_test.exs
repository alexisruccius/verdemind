defmodule VerdemindWeb.LayoutsTest do
  use VerdemindWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  describe "Layouts" do
    test "renders root layout with inner_content" do
      # assert %Phoenix.LiveView.Rendered{} = VerdemindWeb.Layouts.root(%{})
      assert render_to_string(VerdemindWeb.Layouts, "root", "html", %{
               inner_content: "inner_content_example"
             }) =~ "inner_content_example"

      assert VerdemindWeb.html() |> is_tuple()
    end

    test "has __phoenix_verify_routes__" do
      assert :ok == VerdemindWeb.Layouts.__phoenix_verify_routes__([])
    end
  end
end
