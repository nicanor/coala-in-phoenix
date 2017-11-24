defmodule KoalaWeb.PageView do
  use KoalaWeb, :view

  def path_for("page"), do: "paginas"
  def path_for("recipe"), do: "recetas"
  def path_for("article"), do: "articulos"
  def path_for("famous"), do: "famoso"
  def path_for("faq"), do: "preguntas-frequentes"

end
