defmodule GrapevineWeb.PostLive do
  use GrapevineWeb, :live_view

  alias Grapevine.{Accounts, Posts}

  # this will run when "user_token" is present in the session map,
  # which will happen if there is a logged-in user
  def mount(_params, %{"user_token" => token}, socket) do
    posts = Posts.show_all()
    user = Accounts.get_user_by_session_token(token)
    {:ok, assign(socket, posts: posts, current_user: user, post_id: nil)}
  end

  # I think you will want to assign current_user to `nil` here so that you can
  # still refer to `@current_user` assignment in the template to check its value.
  # If there is no such key in socket assigns at all, the template will through an error. You can double check me on this though.
  def mount(_params, _session, socket) do
    posts = Posts.show_all()
    {:ok, assign(socket, posts: posts, current_user: nil, post_id: nil)}
  end

  def handle_params(%{"id" => id}, _, %{assigns: %{live_action: :edit}} = socket) do
    {:noreply, assign(socket, post_id: id)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete-post", %{"post-id" => id}, socket) do
    id
    |> String.to_integer()
    |> Posts.delete()

    posts = Posts.show_all()

    {:noreply, assign(socket, posts: posts)}
  end
end
