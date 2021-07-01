defmodule Grapevine.Repo.Migrations.CreateResources do
  use Ecto.Migration

  def change do
    create table(:resources) do
      add :title, :string
      add :content, :string

      timestamps()
    end
  end
end
