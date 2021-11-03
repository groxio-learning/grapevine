defmodule Grapevine.Like do
  use Ecto.Schema

  import Ecto.Changeset

  alias Grapevine.Accounts.User
  alias Grapevine.Post

  schema "likes" do
    belongs_to :user, User, foreign_key: :user_id
    belongs_to :post, Post, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:post_id)
    |> unique_constraint([:user_id, :post_id])
  end
end
