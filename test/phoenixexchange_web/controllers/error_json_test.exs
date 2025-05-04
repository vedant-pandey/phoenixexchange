defmodule PhoenixexchangeWeb.ErrorJSONTest do
  use PhoenixexchangeWeb.ConnCase, async: true

  test "renders 404" do
    assert PhoenixexchangeWeb.ErrorJSON.render("404.json", %{}) == %{
             errors: %{detail: "Not Found"}
           }
  end

  test "renders 500" do
    assert PhoenixexchangeWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
