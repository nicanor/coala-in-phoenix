defmodule KoalaWeb.PublicationController do
  use KoalaWeb, :controller

  plug :put_layout, "admin.html"

  alias Koala.CMS
  alias Koala.CMS.Publication

  def index(conn, _params) do
    categories = CMS.index()
    render(conn, "index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = CMS.change_publication(%Publication{})
    render(conn, "new.html", changeset: changeset, categories: CMS.list_categories_for_select)
  end

  def create(conn, %{"publication" => publication_params}) do
    case CMS.create_publication(publication_params) do
      {:ok, publication} ->
        conn
        |> put_flash(:info, "Publication created successfully.")
        |> redirect(to: publication_path(conn, :show, publication))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, categories: CMS.list_categories_for_select)
    end
  end

  def show(conn, %{"id" => slug}) do
    publication = CMS.get_publication_with_category!(slug)
    render(conn, "show.html", publication: publication)
  end

  def edit(conn, %{"id" => id}) do
    publication = CMS.get_publication!(id)
    changeset = CMS.change_publication(publication)
    render(conn, "edit.html", publication: publication, changeset: changeset, categories: CMS.list_categories_for_select)
  end

  def update(conn, %{"id" => id, "publication" => publication_params}) do
    publication = CMS.get_publication!(id)

    case CMS.update_publication(publication, publication_params) do
      {:ok, publication} ->
        conn
        |> put_flash(:info, "Publication updated successfully.")
        |> redirect(to: publication_path(conn, :show, publication))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", publication: publication, changeset: changeset, categories: CMS.list_categories_for_select)
    end
  end

  def delete(conn, %{"id" => id}) do
    publication = CMS.get_publication!(id)
    {:ok, _publication} = CMS.delete_publication(publication)

    conn
    |> put_flash(:info, "Publication deleted successfully.")
    |> redirect(to: publication_path(conn, :index))
  end
end
