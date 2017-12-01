defmodule Koala.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias Koala.Repo

  alias Koala.CMS.Publication
  alias Koala.CMS.Category

  @doc """
  Returns the list of publications.

  ## Examples

      iex> list_publications()
      [%Publication{}, ...]

  """
  def list_publications do
    Repo.all(Publication)
  end

  def public_publications do
    query = from(p in Publication, where: p.public == true, select: struct(p, [:title, :slug, :description]))
    Repo.all(query)
  end

  def public_publications(category_id) do
    query = from(p in Publication,
            where: [public: true, category_id: ^category_id],
            select: struct(p, [:title, :slug, :description]))
    Repo.all(query)
  end

  def index do
    query = from c in Category,
      join: p in assoc(c, :publications),
      preload: [publications: p],
      select: [:id, :name, :slug, publications: [:id, :category_id, :title, :slug]]
    Repo.all query
  end


  def public_index do
    query = from c in Category,
      join: p in assoc(c, :publications),
      where: p.public == true,
      preload: [publications: p],
      select: [:id, :name, :slug, publications: [:id, :category_id, :title, :slug]]
    Repo.all query
  end

  @doc """
  Gets a single publication.

  Raises `Ecto.NoResultsError` if the Publication does not exist.

  ## Examples

      iex> get_publication!(123)
      %Publication{}

      iex> get_publication!(456)
      ** (Ecto.NoResultsError)

  """
  def get_publication!(id) when is_integer(id), do: Repo.get!(Publication, id)
  def get_publication!(slug), do: Repo.get_by!(Publication, slug: slug)

  def get_publication_with_category!(slug) do
    query = from p in Publication,
      join: c in  Category,
      on: p.category_id == c.id,
      where: p.slug == ^slug,
      preload: [category: c]
    Repo.one query
  end

  def list_publications_in_category!(category_slug) do
    query = from p in Publication,
      join: c in  Category,
      on: p.category_id == c.id,
      where: c.slug == ^category_slug,
      preload: [category: c]
    Repo.all query
  end

  @doc """
  Creates a publication.

  ## Examples

      iex> create_publication(%{field: value})
      {:ok, %Publication{}}

      iex> create_publication(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_publication(attrs \\ %{}) do
    %Publication{}
    |> Publication.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a publication.

  ## Examples

      iex> update_publication(publication, %{field: new_value})
      {:ok, %Publication{}}

      iex> update_publication(publication, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_publication(%Publication{} = publication, attrs) do
    publication
    |> Publication.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Publication.

  ## Examples

      iex> delete_publication(publication)
      {:ok, %Publication{}}

      iex> delete_publication(publication)
      {:error, %Ecto.Changeset{}}

  """
  def delete_publication(%Publication{} = publication) do
    Repo.delete(publication)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking publication changes.

  ## Examples

      iex> change_publication(publication)
      %Ecto.Changeset{source: %Publication{}}

  """
  def change_publication(%Publication{} = publication) do
    Publication.changeset(publication, %{})
  end

  alias Koala.CMS.Image

  @doc """
  Returns the list of images.

  ## Examples

      iex> list_images()
      [%Image{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

      iex> get_image!(123)
      %Image{}

      iex> get_image!(456)
      ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  @doc """
  Creates a image.

  ## Examples

      iex> create_image(%{field: value})
      {:ok, %Image{}}

      iex> create_image(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_image(attrs \\ %{}) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a Image.

  ## Examples

      iex> delete_image(image)
      {:ok, %Image{}}

      iex> delete_image(image)
      {:error, %Ecto.Changeset{}}

  """
  def delete_image(%Image{} = image) do
    Repo.delete(image)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking image changes.

  ## Examples

      iex> change_image(image)
      %Ecto.Changeset{source: %Image{}}

  """
  def change_image(%Image{} = image) do
    Image.changeset(image, %{})
  end


  @doc """
  Returns the list of categories.

  ## Examples

      iex> list_categories()
      [%Category{}, ...]

  """
  def list_categories do
    Repo.all(Category)
  end

  def list_categories_with_publications do
    Repo.all from c in Category, preload: [:publications]
  end

  def list_categories_for_select do
    Repo.all from c in Category, order_by: c.name, select: {c.name, c.id}
  end

  @doc """
  Gets a single category.

  Raises `Ecto.NoResultsError` if the Category does not exist.

  ## Examples

      iex> get_category!(123)
      %Category{}

      iex> get_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_category!(id) when is_integer(id), do: Repo.get!(Category, id)
  def get_category!(slug), do: Repo.get_by!(Category, slug: slug)

  @doc """
  Creates a category.

  ## Examples

      iex> create_category(%{field: value})
      {:ok, %Category{}}

      iex> create_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a category.

  ## Examples

      iex> update_category(category, %{field: new_value})
      {:ok, %Category{}}

      iex> update_category(category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Category.

  ## Examples

      iex> delete_category(category)
      {:ok, %Category{}}

      iex> delete_category(category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking category changes.

  ## Examples

      iex> change_category(category)
      %Ecto.Changeset{source: %Category{}}

  """
  def change_category(%Category{} = category) do
    Category.changeset(category, %{})
  end
end
