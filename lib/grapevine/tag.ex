defmodule Grapevine.Tag do
  use Ecto.Schema

  import Ecto.Changeset
  alias Grapevine.Post

  schema "tags" do
    field :name, :string

    many_to_many :posts, Post, join_through: "posts_tags"

    timestamps()
  end

  @doc false
  def changeset(like, attrs) do
    like
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
