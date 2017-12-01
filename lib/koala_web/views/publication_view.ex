defmodule KoalaWeb.PublicationView do
  use KoalaWeb, :view

  def tick(true), do: content_tag(:span, gettext("yes"), class: "good")
  def tick(false), do: ""

end
