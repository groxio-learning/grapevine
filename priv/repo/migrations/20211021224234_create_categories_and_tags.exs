defmodule Grapevine.Repo.Migrations.CreateCategoriesAndTags do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name, :citext, null: false

      timestamps()
    end

    create table(:tags) do
      add :name, :citext, null: false

      timestamps()
    end

    create table(:posts_tags) do
      add :post_id, references(:posts)
      add :tag_id, references(:tags)

      timestamps()
    end

    alter table(:posts) do
      add :category_id, references(:categories)
    end

    create index(:posts, [:category_id])
    create unique_index(:posts_tags, [:post_id, :tag_id])
  end
end
