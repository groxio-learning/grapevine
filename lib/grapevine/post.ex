defmodule Grapevine.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Grapevine.Accounts.User
  alias Grapevine.Category
  alias Grapevine.Like
  alias Grapevine.Tag

  schema "posts" do
    field :content, :string
    field :title, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :category, Category, foreign_key: :category_id

    has_many :likes, Like, on_delete: :delete_all

    many_to_many :tags, Tag, join_through: "posts_tags"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id, :category_id])
    |> validate_required([:title, :content, :user_id])
    |> validate_url()
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:category_id)
  end

  def validate_url(changeset) do
    validate_change(changeset, :content, fn :content, content ->
      uri = URI.parse(content)

      if uri.scheme != nil && uri.host =~ ~r/(www\.)?[[:alnum:]]\.[[:alnum:]]/i &&
           uri.host =~ ~r/\A[^\.]/i do
        []
      else
        [content: "invalid format"]
      end
    end)
  end
end
