defmodule GrapevineWeb.PostLive do
  use GrapevineWeb, :live_view

  alias Grapevine.Accounts

  # this will run when "user_token" is present in the session map,
  # which will happen if there is a logged-in user
  def mount(_params, %{"user_token" => token}, socket) do
    posts = Grapevine.Posts.show_all()
    case Accounts.get_user_by_session_token(token) do
      nil -> {:ok, assign(socket,  posts: posts, current_user: nil)}
      current_user -> {:ok, assign(socket, posts: posts, current_user: current_user)}
    end
  end
  # I think you will want to assign current_user to `nil` here so that you can
  # still refer to `@current_user` assignment in the template to check its value.
  # If there is no such key in socket assigns at all, the template will through an error. You can double check me on this though.
  def mount(_params, _session, socket) do
   posts = Grapevine.Posts.show_all()
   {:ok, assign(socket, posts: posts, current_user: nil)}
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    Grapevine.Posts.create(post_params, socket.assigns.current_user.id)
    {:noreply, push_redirect(socket, to: "/posts")}
  end

end
