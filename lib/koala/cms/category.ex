defmodule Koala.CMS.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.CMS.Category

  @derive {Phoenix.Param, key: :slug}

  schema "categories" do
    field(:description, :string)
    field(:name, :string)
    field(:slug, :string)
    has_many(:publications, Koala.CMS.Publication)

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    category
    |> cast(attrs, [:name, :description, :slug])
    |> add_slug
    |> validate_required([:name, :description, :slug])
    |> unique_constraint(:name)
    |> unique_constraint(:slug)
  end

  def add_slug(%Ecto.Changeset{changes: %{name: name}} = changeset) do
    put_change(changeset, :slug, Slugger.slugify_downcase(name))
  end

  def add_slug(changeset), do: changeset
end
