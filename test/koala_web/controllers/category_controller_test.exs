defmodule KoalaWeb.CategoryControllerTest do
  use KoalaWeb.ConnCase

  alias Koala.CMS

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:category) do
    {:ok, category} = CMS.create_category(@create_attrs)
    category
  end

  describe "new category" do
    test "renders form", %{conn: conn} do
      conn = get(conn, category_path(conn, :new))
      assert html_response(conn, 200) =~ "Nueva categoría"
    end
  end

  describe "create category" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, category_path(conn, :create), category: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == category_path(conn, :show, id)

      conn = get(conn, category_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Categoría"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, category_path(conn, :create), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Nueva categoría"
    end
  end

  describe "edit category" do
    setup [:create_category]

    test "renders form for editing chosen category", %{conn: conn, category: category} do
      conn = get(conn, category_path(conn, :edit, category))
      assert html_response(conn, 200) =~ "Editar categoría"
    end
  end

  describe "update category" do
    setup [:create_category]

    test "redirects when data is valid", %{conn: conn, category: category} do
      conn = put(conn, category_path(conn, :update, category), category: @update_attrs)
      # To have updated slug.
      category = CMS.get_category!(category.id)

      assert redirected_to(conn) == category_path(conn, :show, category)

      conn = get(conn, category_path(conn, :show, category))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, category: category} do
      conn = put(conn, category_path(conn, :update, category), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar categoría"
    end
  end

  describe "delete category" do
    setup [:create_category]

    test "deletes chosen category", %{conn: conn, category: category} do
      conn = delete(conn, category_path(conn, :delete, category))
      assert redirected_to(conn) == publication_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, category_path(conn, :show, category))
      end)
    end
  end

  defp create_category(_) do
    category = fixture(:category)
    {:ok, category: category}
  end
end
