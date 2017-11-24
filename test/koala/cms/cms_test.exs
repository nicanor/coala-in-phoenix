defmodule Koala.CMSTest do
  use Koala.DataCase

  alias Koala.CMS

  describe "publications" do
    alias Koala.CMS.Publication

    @valid_attrs %{content: "some content", description: "some description", facebook_path: "some facebook_path", public: true, publication_date: ~D[2010-04-17], slug: "some-slug", title: "some title", type: "page"}
    @update_attrs %{content: "some updated content", description: "some updated description", facebook_path: "some updated facebook_path", public: false, publication_date: ~D[2011-05-18], slug: "some-updated-slug", title: "some updated title", type: "recipe"}
    @invalid_attrs %{content: nil, description: nil, facebook_path: nil, public: nil, publication_date: nil, slug: nil, title: nil, type: nil}

    def publication_fixture(attrs \\ %{}) do
      {:ok, publication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CMS.create_publication()

      publication
    end

    test "valid_types/0 returns all valid_types" do
      assert CMS.valid_types() == Publication.valid_types()
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
      assert publication.slug == "some-slug"
      assert publication.title == "some title"
      assert publication.type == "page"
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
      assert publication.slug == "some-updated-slug"
      assert publication.title == "some updated title"
      assert publication.type == "recipe"
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
end
