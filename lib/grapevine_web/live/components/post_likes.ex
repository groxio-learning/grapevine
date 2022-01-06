defmodule GrapevineWeb.Components.PostLikes do
  use GrapevineWeb, :live_component

  @impl true
  def update(assigns, socket) do
    {:ok, socket |> assign(assigns)}
  end

  @impl true
  def handle_event("like", _, %{assigns: %{post: post, current_user: user}} = socket) do
    Grapevine.Posts.like(%{user_id: user.id, post_id: post.id})
    post = Grapevine.Posts.get(post.id)

    Phoenix.PubSub.broadcast(Grapevine.PubSub, "posts", {:updated_post, post})

    {:noreply, socket}
  end

  @impl true
  def handle_event("unlike", _, %{assigns: %{post: post, current_user: user}} = socket) do
    Grapevine.Posts.unlike(%{user_id: user.id, post_id: post.id})
    post = Grapevine.Posts.get(post.id)

    Phoenix.PubSub.broadcast(Grapevine.PubSub, "posts", {:updated_post, post})

    {:noreply, socket}
  end
end
