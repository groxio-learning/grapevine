defmodule Grapevine.Post do
  use Ecto.Schema
  import Ecto.Changeset
  alias Grapevine.Accounts.User
  alias Grapevine.Like

  schema "posts" do
    field :content, :string
    field :title, :string
    belongs_to :user, User, foreign_key: :user_id
    has_many :likes, Like

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :user_id])
    |> validate_required([:title, :content, :user_id])
    |> validate_url()
    |> foreign_key_constraint(:user_id)
  end

  def validate_url(changeset) do
    validate_change(changeset, :content, fn :content, content ->
      uri = URI.parse(content)
      if uri.scheme != nil && uri.host =~ ~r/(www\.)?[[:alnum:]]\.[[:alnum:]]/i && uri.host =~ ~r/\A[^\.]/i do
        []
      else
        [content: "Check the url." ]
      end
    end)
  end

end



