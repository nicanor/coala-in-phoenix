defmodule Koala.Repo.Migrations.AddCategoryToPublication do
  use Ecto.Migration

  def change do
    alter table(:publications) do
      add :category_id, references(:categories)
    end
    create index(:publications, [:category_id])
  end
end
