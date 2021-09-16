defmodule PostLive.LikesComponent do


  use GrapevineWeb, :live_component

  def update(assigns, socket) do
    {:ok, socket |> assign(assigns) }
  end

  def handle_event("like_it", _, %{assigns: %{post: post, current_user: user}} = socket) do
    Grapevine.Posts.create_like(%{user_id: user.id, post_id: post.id})
    post = Grapevine.Posts.get(post.id)
    {:noreply, 
      socket
      |> assign(%{post: post})
    }



  end



end
