defmodule KoalaWeb.PageControllerTest do
  use KoalaWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Coala"
  end
end
