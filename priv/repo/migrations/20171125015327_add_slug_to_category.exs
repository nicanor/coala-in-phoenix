defmodule Koala.Repo.Migrations.AddSlugToCategory do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :slug, :string, null: false
    end
    create unique_index(:categories, [:slug])
  end
end
