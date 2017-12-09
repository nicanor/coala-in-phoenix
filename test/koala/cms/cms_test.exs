defmodule Koala.CMSTest do
  use Koala.DataCase

  alias Koala.CMS

  describe "publications" do
    alias Koala.CMS.Publication

    @valid_attrs %{content: "some content", description: "some description", facebook_path: "some facebook_path", public: true, publication_date: ~D[2010-04-17], title: "some title"}
    @update_attrs %{content: "some updated content", description: "some updated description", facebook_path: "some updated facebook_path", public: false, publication_date: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{content: nil, description: nil, facebook_path: nil, public: nil, publication_date: nil,  title: nil}

    def publication_fixture(attrs \\ %{}) do
      {:ok, publication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_publication()

      publication
    end

    test "list_publications/0 returns all publications" do
      publication = publication_fixture()
      assert CMS.list_publications() == [publication]
    end

    test "get_publication!/1 returns the publication with given id" do
      publication = publication_fixture()
      assert CMS.get_publication!(publication.id) == publication
    end

    test "create_publication/1 with valid data creates a publication" do
      assert {:ok, %Publication{} = publication} = CMS.create_publication(@valid_attrs)
      assert publication.content == "some content"
      assert publication.description == "some description"
      assert publication.facebook_path == "some facebook_path"
      assert publication.public == true
      assert publication.publication_date == ~D[2010-04-17]
      assert publication.slug == "some-title"
      assert publication.title == "some title"
    end

    test "create_publication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_publication(@invalid_attrs)
    end

    test "update_publication/2 with valid data updates the publication" do
      publication = publication_fixture()
      assert {:ok, publication} = CMS.update_publication(publication, @update_attrs)
      assert %Publication{} = publication
      assert publication.content == "some updated content"
      assert publication.description == "some updated description"
      assert publication.facebook_path == "some updated facebook_path"
      assert publication.public == false
      assert publication.publication_date == ~D[2011-05-18]
      assert publication.slug == "some-updated-title"
      assert publication.title == "some updated title"
    end

    test "update_publication/2 with invalid data returns error changeset" do
      publication = publication_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_publication(publication, @invalid_attrs)
      assert publication == CMS.get_publication!(publication.id)
    end

    test "delete_publication/1 deletes the publication" do
      publication = publication_fixture()
      assert {:ok, %Publication{}} = CMS.delete_publication(publication)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_publication!(publication.id) end
    end

    test "change_publication/1 returns a publication changeset" do
      publication = publication_fixture()
      assert %Ecto.Changeset{} = CMS.change_publication(publication)
    end
  end

  describe "images" do
    alias Koala.CMS.Image

    @valid_attrs %{image: Path.dirname(__DIR__) <> "/cms/example.jpg"}
    @invalid_attrs %{image: nil}

    def image_fixture(attrs \\ %{}) do
      {:ok, image} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_image()

      image
    end

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert CMS.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert CMS.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      assert {:ok, %Image{} = image} = CMS.create_image(@valid_attrs)
      assert image.image.file_name == "example.jpg"
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_image(@invalid_attrs)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = CMS.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = CMS.change_image(image)
    end
  end

  describe "categories" do
    alias Koala.CMS.Category

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def category_fixture(attrs \\ %{}) do
      {:ok, category} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_category()

      category
    end

    test "list_categories/0 returns all categories" do
      category = category_fixture()
      assert CMS.list_categories() == [category]
    end

    test "get_category!/1 returns the category with given id" do
      category = category_fixture()
      assert CMS.get_category!(category.id) == category
    end

    test "create_category/1 with valid data creates a category" do
      assert {:ok, %Category{} = category} = CMS.create_category(@valid_attrs)
      assert category.description == "some description"
      assert category.name == "some name"
    end

    test "create_category/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CMS.create_category(@invalid_attrs)
    end

    test "update_category/2 with valid data updates the category" do
      category = category_fixture()
      assert {:ok, category} = CMS.update_category(category, @update_attrs)
      assert %Category{} = category
      assert category.description == "some updated description"
      assert category.name == "some updated name"
    end

    test "update_category/2 with invalid data returns error changeset" do
      category = category_fixture()
      assert {:error, %Ecto.Changeset{}} = CMS.update_category(category, @invalid_attrs)
      assert category == CMS.get_category!(category.id)
    end

    test "delete_category/1 deletes the category" do
      category = category_fixture()
      assert {:ok, %Category{}} = CMS.delete_category(category)
      assert_raise Ecto.NoResultsError, fn -> CMS.get_category!(category.id) end
    end

    test "change_category/1 returns a category changeset" do
      category = category_fixture()
      assert %Ecto.Changeset{} = CMS.change_category(category)
    end
  end
end
