defmodule KoalaWeb.CategoryController do
  use KoalaWeb, :controller

  plug(KoalaWeb.Authorize, ["admin", "editor", "guest"])

  alias Koala.CMS
  alias Koala.CMS.Category

  def new(conn, _params) do
    changeset = CMS.change_category(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    case CMS.create_category(category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    category = CMS.get_category_with_publications!(id)
    render(conn, "show.html", category: category)
  end

  def edit(conn, %{"id" => id}) do
    category = CMS.get_category!(id)
    changeset = CMS.change_category(category)
    render(conn, "edit.html", category: category, changeset: changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = CMS.get_category!(id)

    case CMS.update_category(category, category_params) do
      {:ok, category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :show, category))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", category: category, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = CMS.get_category!(id)
    {:ok, _category} = CMS.delete_category(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: publication_path(conn, :index))
  end
end
