defmodule Koala.CMS.Publication do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.CMS.Publication

  @valid_types [
                 "Artículo": "article",
                 "Página": "page",
                 "Receta": "recipe",
                 "Pregunta Frecuente": "faq",
                 "Primaria": "primary"
               ]

  schema "publications" do
    field :content, :string
    field :description, :string
    field :facebook_path, :string
    field :public, :boolean, default: false
    field :publication_date, :date
    field :slug, :string
    field :title, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(%Publication{} = publication, attrs) do
    publication
    |> cast(attrs, [:title, :slug, :type, :description, :content, :public, :publication_date, :facebook_path])
    |> validate_required([:title, :slug, :type, :description, :content, :public, :publication_date, :facebook_path])
    |> validate_inclusion(:type, valid_types_values)
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/)
    |> unique_constraint(:slug)
  end

  def valid_types do
    @valid_types
  end

  defp valid_types_values do
    Keyword.values(valid_types)
  end
end
