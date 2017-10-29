defmodule Koala.Repo.Migrations.CreatePublications do
  use Ecto.Migration

  def change do
    create table(:publications) do
      add :title, :string
      add :slug, :string
      add :type, :string
      add :description, :text
      add :content, :text
      add :public, :boolean, default: false, null: false
      add :publication_date, :date
      add :facebook_path, :string

      timestamps()
    end

    create unique_index(:publications, [:slug])

  end
end
