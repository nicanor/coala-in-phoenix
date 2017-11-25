defmodule KoalaWeb.ImageControllerTest do
  use KoalaWeb.ConnCase
  alias Koala.CMS

  @create_attrs %{image: Path.dirname(__DIR__) <> "/img/example.jpg"}
  @invalid_attrs %{image: nil}

  def fixture(:image) do
    {:ok, image} = CMS.create_image(@create_attrs)
    image
  end

  describe "index" do
    test "lists all images", %{conn: conn} do
      conn = get conn, image_path(conn, :index)
      assert html_response(conn, 200) =~ "Lista de imágenes"
    end
  end

  describe "new image" do
    test "renders form", %{conn: conn} do
      conn = get conn, image_path(conn, :new)
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "create image" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, image_path(conn, :create), image: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == image_path(conn, :show, id)

      conn = get conn, image_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Imágen"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, image_path(conn, :create), image: @invalid_attrs
      assert html_response(conn, 200) =~ "New Image"
    end
  end

  describe "delete image" do
    setup [:create_image]

    test "deletes chosen image", %{conn: conn, image: image} do
      conn = delete conn, image_path(conn, :delete, image)
      assert redirected_to(conn) == image_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, image_path(conn, :show, image)
      end
    end
  end

  defp create_image(_) do
    image = fixture(:image)
    {:ok, image: image}
  end
end
