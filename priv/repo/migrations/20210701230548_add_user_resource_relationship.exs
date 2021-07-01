defmodule Grapevine.Repo.Migrations.AddUserResourceRelationship do
  use Ecto.Migration

  def up do
    alter table(:resources) do
      add :user_id, references(:users)
    end

    create index(:resources, [:user_id])
  end

  def down do
    drop index(:resources, [:user_id])

    alter table(:resources) do
      remove :user_id
    end
  end
end
