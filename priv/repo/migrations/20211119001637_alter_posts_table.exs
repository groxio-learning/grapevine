defmodule Grapevine.Repo.Migrations.AlterPostsTable do
  use Ecto.Migration

  def change do

    drop constraint(:likes, :likes_post_id_fkey)

    alter table(:likes) do
      modify :post_id, references(:posts, on_delete: :delete_all)
    end


  end
end
