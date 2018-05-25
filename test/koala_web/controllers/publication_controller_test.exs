defmodule KoalaWeb.PublicationControllerTest do
  use KoalaWeb.ConnCase

  alias Koala.CMS
  alias Koala.Accounts

  @category_create_attrs %{description: "some description", name: "some name"}

  @create_attrs %{
    content: "some content",
    description: "some description",
    facebook_path: "some facebook_path",
    public: true,
    publication_date: ~D[2010-04-17],
    title: "some title"
  }
  @update_attrs %{
    content: "some updated content",
    description: "some updated description",
    facebook_path: "some updated facebook_path",
    public: false,
    publication_date: ~D[2011-05-18],
    title: "some updated title"
  }
  @invalid_attrs %{
    content: nil,
    description: nil,
    facebook_path: nil,
    public: nil,
    publication_date: nil,
    title: nil
  }

  def fixture(:publication) do
    {:ok, category} = CMS.create_category(@category_create_attrs)
    {:ok, publication} = CMS.create_publication(Map.put(@create_attrs, :category_id, category.id))
    publication
  end

  describe "index" do
    test "lists all publications", %{conn: conn} do
      conn = get(conn, publication_path(conn, :index))
      assert html_response(conn, 200) =~ "Lista de publicaciones"
    end
  end

  describe "new publication" do
    test "renders form", %{conn: conn} do
      conn = get(conn, publication_path(conn, :new))
      assert html_response(conn, 200) =~ "Nueva publicación"
    end
  end

  describe "create publication" do
    test "redirects to show when data is valid", %{conn: conn} do
      {:ok, category} = CMS.create_category(@category_create_attrs)

      conn =
        post(
          conn,
          publication_path(conn, :create),
          publication: Map.put(@create_attrs, :category_id, category.id)
        )

      assert %{id: id} = redirected_params(conn)
      publication = CMS.get_publication!(id)
      assert redirected_to(conn) == publication_path(conn, :show, publication)

      conn = get(conn_with_current_user(), publication_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Publicación"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, publication_path(conn, :create), publication: @invalid_attrs)
      assert html_response(conn, 200) =~ "Nueva publicación"
    end
  end

  describe "edit publication" do
    setup [:create_publication]

    test "renders form for editing chosen publication", %{conn: conn, publication: publication} do
      conn = get(conn, publication_path(conn, :edit, publication))
      assert html_response(conn, 200) =~ "Editar Publicación"
    end
  end

  describe "update publication" do
    setup [:create_publication]

    test "redirects when data is valid", %{conn: conn, publication: publication} do
      conn = put(conn, publication_path(conn, :update, publication), publication: @update_attrs)
      # To have updated slug.
      publication = CMS.get_publication!(publication.id)
      assert redirected_to(conn) == publication_path(conn, :show, publication)

      conn = recycle(conn)
      conn = get(conn, publication_path(conn, :show, publication))
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, publication: publication} do
      conn = put(conn, publication_path(conn, :update, publication), publication: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar Publicación"
    end
  end

  describe "delete publication" do
    setup [:create_publication]

    test "deletes chosen publication", %{conn: conn, publication: publication} do
      conn = delete(conn, publication_path(conn, :delete, publication))
      assert redirected_to(conn) == publication_path(conn, :index)

      assert_error_sent(404, fn ->
        get(conn, publication_path(conn, :show, publication))
      end)
    end
  end

  defp create_publication(_) do
    publication = fixture(:publication)
    {:ok, conn: build_conn(), publication: publication}
  end

  setup do
    {:ok, conn: conn_with_current_user()}
  end

  defp conn_with_current_user do
    current_user = fixture(:editor)
    assign(build_conn(), :current_user, current_user)
  end

  def fixture(:editor) do
    {:ok, user} =
      Accounts.create_user(%{
        password: "some-password",
        password_confirmation: "some-password",
        email: "editor@email.com",
        role: "admin"
      })

    user
  end
end
