defmodule Grapevine.Repo.Migrations.CreateLikes do
  use Ecto.Migration

  def change do
    create table(:likes) do
      add :user_id, references(:users)
      add :post_id, references(:posts)

      timestamps()
    end

    create unique_index(:likes, [:user_id, :post_id])
  end
end
