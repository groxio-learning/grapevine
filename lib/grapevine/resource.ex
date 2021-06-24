defmodule Grapevine.Resource do
  use Ecto.Schema
  import Ecto.Changeset

  schema "resources" do
    field :content, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(resource, attrs) do
    resource
    |> cast(attrs, [:title, :content])
    |> validate_required([:title, :content])
  end
end
