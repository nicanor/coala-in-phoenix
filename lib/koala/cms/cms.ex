defmodule Koala.CMS do
  @moduledoc """
  The CMS context.
  """

  import Ecto.Query, warn: false
  alias Koala.Repo

  alias Koala.CMS.Publication

  @doc """
  Returns valid page types
  """
  def valid_types do
    Publication.valid_types
  end

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
    query = from(p in Publication, where: p.public == true, select: struct(p, [:title, :slug, :type, :description]))
    Repo.all(query)
  end

  def public_recipes do
    public_publications("recipe")
  end

  def public_publications(type) do
    query = from(p in Publication, where: [type: ^type, public: true], select: struct(p, [:title, :slug, :type, :description]))
    Repo.all(query)
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
  def get_publication!(slug), do: Repo.get_by!(Publication, slug: slug)
  def get_publication!(type, slug), do: Repo.get_by!(Publication, type: type, slug: slug)

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
end