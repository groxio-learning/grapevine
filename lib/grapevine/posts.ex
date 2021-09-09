defmodule Grapevine.Posts do
  alias Grapevine.Post
  alias Grapevine.Repo
  alias Grapevine.Like

  def update(changeset, attrs) do
    changeset
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def create(attrs, user_id) do
    attrs = Map.put(attrs, "user_id", user_id)

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def create_like(attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def delete!(id, user_id) do
    with %Post{user_id: ^user_id} = post <-
           Repo.get!(Post, id) do
      Repo.delete(post)
    end
  end

  def show_all() do
    Repo.all(Post)
  end

  def post_changeset(%{post: post}) do
    post |> Post.changeset(%{})
  end

  def post_changeset(_) do
    %Post{} |> Post.changeset(%{})
  end
end
