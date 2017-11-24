defmodule KoalaWeb.PublicationView do
  use KoalaWeb, :view

  def type_name(type) do
    types()
    |> Enum.map(fn {key, value} -> {value, key} end)
    |> Enum.into(%{})
    |> Map.fetch!(type)
  end

  def types do
    [
      {dgettext("types", "Article"), "article"},
      {dgettext("types", "Page"), "page"},
      {dgettext("types", "Recipe"), "recipe"},
      {dgettext("types", "Frequently asked question"), "faq"},
      {dgettext("types", "Primary"), "primary"}
    ]
  end

  def tick(true), do: content_tag(:span, gettext("yes"), class: "good")
  def tick(false), do: ""

end
