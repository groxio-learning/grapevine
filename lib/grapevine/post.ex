defmodule Grapevine.Post do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Grapevine.Accounts.User

  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :user, User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
