defmodule Grapevine.Posts do
  import Ecto.Query

  alias Grapevine.{Like, Post, Category}
  alias Grapevine.Repo

  def show_all do
    Repo.all(with_likes())
    |> Repo.preload(:category)

  end

  def get(id) do
    Post
    |> Repo.get!(id)
    |> Repo.preload([:likes, :category])
  end

  def create(attrs, user_id) do
    attrs = Map.put(attrs, "user_id", user_id)

    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update(changeset, attrs) do
    changeset
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  def delete!(id, user_id) do
    with %Post{user_id: ^user_id} = post <-
           Repo.get!(Post, id) do
      Repo.delete(post)
    end
  end

  def with_likes do
    from p in Post,
      left_join: l in assoc(p, :likes),
      preload: [likes: l],
      order_by: [desc: :inserted_at]
  end

  def like(attrs) do
    %Like{}
    |> Like.changeset(attrs)
    |> Repo.insert()
  end

  def unlike(attrs) do
    with %Like{} = like <-
           attrs
           |> get_like()
           |> Repo.one() do
      Repo.delete(like)
    end
  end

  def get_like(%{user_id: user_id, post_id: post_id} = _attrs) do
    from l in Like, where: [user_id: ^user_id, post_id: ^post_id]
  end

  def get_categories(fields \\ [:name, :id]) do
    query = from c in Category, select: map(c, ^fields)

    Repo.all(query)
  end

  def post_changeset(%{post: post}) do
    Post.changeset(post, %{})
  end

  def post_changeset(_) do
    Post.changeset(%Post{}, %{})
  end
end
