defmodule KoalaWeb.PublicController do
  use KoalaWeb, :controller

  alias Koala.CMS

  def index(conn, _params) do
    categories = CMS.public_index()
    render(conn, "index.html", categories: categories)
  end

  def show(conn, %{"category_slug" => category_slug, "publication_slug" => publication_slug}) do
    publication = CMS.get_publication_with_category!(publication_slug)

    case publication.category.slug == category_slug do
      false ->
        conn
        |> put_status(:not_found)
        |> put_view(KoalaWeb.ErrorView)
        |> render("404.html")

      true ->
        publications = CMS.public_publications(publication.category_id)

        render(
          conn,
          "show.html",
          publication: publication,
          category: publication.category,
          publications: publications
        )
    end
  end
end
