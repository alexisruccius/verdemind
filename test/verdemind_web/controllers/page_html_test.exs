defmodule VerdemindWeb.PageHTMLTest do
  use VerdemindWeb.ConnCase, async: true

  test "has __phoenix_verify_routes__" do
    assert :ok == VerdemindWeb.PageHTML.__phoenix_verify_routes__([])
  end
end
