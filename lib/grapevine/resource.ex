defmodule Grapevine.Resource do
  use Ecto.Schema
  import Ecto.Changeset
  alias Grapevine.Accounts.User

  schema "resources" do
    field :content, :string
    field :title, :string
    belongs_to :user, User
    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:title, :content, :user])
    |> validate_required([:title, :content, :user])
  end
end
