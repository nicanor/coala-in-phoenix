defmodule KoalaWeb.PublicController do
  use KoalaWeb, :controller

  alias Koala.CMS

  def index(conn, _params) do
    categories = CMS.public_index()
    render(conn, "index.html", categories: categories)
  end

  def show(conn, %{"category_slug" => category_slug, "publication_slug" => publication_slug}) do
    category = CMS.get_category!(category_slug)
    publication = CMS.get_publication!(publication_slug)

    case publication.category_id == category.id do
      false ->
        conn
          |> put_status(:not_found)
          |> put_view(KoalaWeb.ErrorView)
          |> render("404.html")
      true ->
        publications = CMS.public_publications(category.id)

        render(conn, "show.html", publication: publication, category: category, publications: publications)
    end
  end

end
