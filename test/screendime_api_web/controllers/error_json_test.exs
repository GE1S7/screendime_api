defmodule ScreendimeApiWeb.ErrorJSONTest do
  use ScreendimeApiWeb.ConnCase, async: true

  test "renders 404" do
    assert ScreendimeApiWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert ScreendimeApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
