defmodule GrapevineWeb.PostLive do
  use GrapevineWeb, :live_view

  alias Grapevine.{Accounts, Posts}

  # this will run when "user_token" is present in the session map,
  # which will happen if there is a logged-in user
  def mount(_params, %{"user_token" => token}, socket) do
    user = Accounts.get_user_by_session_token(token)
    Phoenix.PubSub.subscribe(Grapevine.PubSub, "posts")

    {:ok,
     socket
     |> base_mount()
     |> assign(category_id: "0")
     |> assign(current_user: user)}
  end

  # I think you will want to assign current_user to `nil` here so that you can
  # still refer to `@current_user` assignment in the template to check its value.
  # If there is no such key in socket assigns at all, the template will through an error. You can double check me on this though.
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> base_mount()
     |> assign(current_user: nil)}
  end

  defp base_mount(socket) do
    posts = Posts.show_all()
    categories = Posts.get_categories()
    all_categories = [%{id: 0, name: "All"} | categories]

    assign(socket,
      categories: all_categories,
      all_posts: posts,
      posts: posts,
      post_id: nil,
      like_order: :asc,
      inserted_at_order: :desc
    )
  end

  def handle_params(%{"id" => id}, _, %{assigns: %{live_action: :edit}} = socket) do
    {:noreply, assign(socket, post_id: id)}
  end

  def handle_params(%{"sort_by" => "likes"}, _uri, socket) do
    {
      :noreply,
      assign(socket, like_order: toggle_order(socket.assigns.like_order))
      |> assign_like_order("likes")
    }
  end

  def handle_params(%{"sort_by" => "inserted_at"}, _uri, socket) do
    {
      :noreply,
      assign(socket, inserted_at_order: toggle_order(socket.assigns.inserted_at_order))
      |> assign_inserted_at_order("inserted_at")
    }
  end

  def handle_params(_, _, socket) do
    {:noreply, socket}
  end

  def handle_event("delete-post", %{"post-id" => id}, socket) do
    id
    |> String.to_integer()
    |> Posts.delete!(socket.assigns.current_user.id)

    posts = Posts.show_all()

    {:noreply, assign(socket, posts: posts, all_posts: posts)}
  end

  def handle_info({:post_created, post}, socket) do
    posts = [post | socket.assigns.posts]

    {:noreply, assign(socket, posts: posts)}
  end

  def handle_info({:updated_post, post}, socket) do
    p_index = Enum.find_index(socket.assigns.posts, fn x -> x.id == post.id end)
    posts = List.replace_at(socket.assigns.posts, p_index, post)
    {:noreply, assign(socket, posts: posts)}
  end

  def handle_info({:category_filter, "0"}, %{assigns: %{all_posts: all_posts}} = socket) do
    # push_patch(socket, to: Routes.live_path(socket, MyLive, page + 1))
    {:noreply, assign(socket, posts: all_posts, category_id: "0")}
  end

  def handle_info({:category_filter, category_id}, %{assigns: %{all_posts: all_posts}} = socket) do
    filtered_posts = Enum.filter(all_posts, &(&1.category_id == String.to_integer(category_id)))
    {:noreply, assign(socket, posts: filtered_posts, category_id: category_id)}
  end

  def sort_posts(posts, "inserted_at", :desc) do
    Enum.sort_by(posts, & &1.inserted_at, {:desc, NaiveDateTime})
  end

  def sort_posts(posts, "inserted_at", :asc) do
    Enum.sort_by(posts, & &1.inserted_at, {:asc, NaiveDateTime})
  end

  def sort_posts(posts, "likes", :desc) do
    Enum.sort_by(posts, &length(&1.likes), :desc)
  end

  def sort_posts(posts, "likes", :asc) do
    Enum.sort_by(posts, &length(&1.likes), :asc)
  end

  def toggle_order(:asc) do
    :desc
  end

  def toggle_order(:desc) do
    :asc
  end

  def assign_like_order(socket, sort_by) do
    posts = sort_posts(socket.assigns.posts, sort_by, socket.assigns.like_order)
    assign(socket, posts: posts)
  end

  def assign_inserted_at_order(socket, sort_by) do
    posts = sort_posts(socket.assigns.posts, sort_by, socket.assigns.inserted_at_order)
    assign(socket, posts: posts)
  end
end
