defmodule Grapevine.Posts do
  alias Grapevine.Post
  alias Grapevine.Repo
  alias Grapevine.Like
  import Ecto.Query

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

  def get(id) do
    Post |> Repo.get!(id) |>  Repo.preload(:likes)
  end

  def create_like(attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def unlike() do
  end

  def delete!(id, user_id) do
    with %Post{user_id: ^user_id} = post <-
           Repo.get!(Post, id) do
      Repo.delete(post)
    end
  end

  def show_all() do
    with_likes()
    |> Repo.all
  end


  def with_likes do
    from p in Post, left_join: l in assoc(p, :likes), preload: [ likes: l ]
  end


  def post_changeset(%{post: post}) do
    post |> Post.changeset(%{})
  end

  def post_changeset(_) do
    %Post{} |> Post.changeset(%{})
  end
end
