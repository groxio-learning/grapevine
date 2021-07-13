defmodule Grapevine.Repo.Migrations.RenameResourceToPost do
  use Ecto.Migration

  def change do
    rename table("resources"), to: table("posts")
  end
end
