defmodule KoalaWeb.PageController do
  use KoalaWeb, :controller

  alias Koala.CMS

  def index(conn, _params) do
    publications = CMS.public_publications()
    render(conn, "index.html", publications: publications)
  end

  def sitemap(conn, _params) do
    publications = CMS.public_publications()
                   |> Enum.group_by(fn (x) -> x.type end)
    render(conn, "sitemap.html", publications: publications)
  end

  def show(conn, %{"id" => id, "category" => category}) do
    publication = CMS.get_publication_with_category!(id)
    publications = CMS.public_publications(publication.type)
    render(conn, "show.html", publication: publication, publications: publications)
  end

  # TODO: refactorizar con page-view
  defp type_from_path("paginas"), do: "page"
  defp type_from_path("recetas"), do: "recipe"
  defp type_from_path("articulos"), do: "articles"
  defp type_from_path("preguntas-frequentes"), do: "faq"
  defp type_from_path(_), do: "page"

end
