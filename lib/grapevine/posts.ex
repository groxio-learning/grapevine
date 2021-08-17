defmodule Grapevine.Posts do
  alias Grapevine.Post
  alias Grapevine.Repo

  # alias Grapevine.Accounts

  def create(attrs, user_id) do
    # user = Accounts.get_user!(user_id)
    attrs = Map.put(attrs, "user_id", user_id)

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def show_all() do
    Repo.all(Post)
  end

  def post_changeset(%{post: post }) do
    post |> Post.changeset(%{})
  end

  def post_changeset(_) do
    %Post{} |> Post.changeset(%{})
  end

end
