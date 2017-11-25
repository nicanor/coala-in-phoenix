defmodule Koala.CMS.Publication do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.CMS.Publication

  @valid_types ["article", "page", "recipe", "faq", "primary"]
  @derive {Phoenix.Param, key: :slug}


  schema "publications" do
    field :content, :string
    field :description, :string
    field :facebook_path, :string
    field :public, :boolean, default: false
    field :publication_date, :date
    field :slug, :string
    field :title, :string
    field :type, :string
    belongs_to :category, Koala.CMS.Category

    timestamps()
  end

  @doc false
  def changeset(%Publication{} = publication, attrs) do
    publication
    |> cast(attrs, [:title, :slug, :type, :description, :content, :public, :publication_date, :facebook_path, :category_id])
    |> add_slug
    |> validate_required([:title, :slug, :type, :description, :content, :public, :publication_date, :facebook_path])
    |> validate_inclusion(:type, valid_types())
    |> validate_format(:slug, ~r/^[a-z0-9]+(?:-[a-z0-9]+)*$/)
    |> unique_constraint(:slug)
  end

  def valid_types do
    @valid_types
  end

  def add_slug(%Ecto.Changeset{changes: %{title: title}} = changeset) do
    put_change(changeset, :slug, Slugger.slugify_downcase(title))
  end
  def add_slug(changeset), do: changeset
end
