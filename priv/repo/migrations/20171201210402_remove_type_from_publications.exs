defmodule Koala.Repo.Migrations.RemoveTypeFromPublications do
  use Ecto.Migration

  def change do
    alter table(:publications) do
      remove :type
    end
  end
end
