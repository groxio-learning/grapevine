defmodule GrapevineWeb.PostLive do
  use GrapevineWeb, :live_view

  def mount(_params, _session, socket) do
   posts = Grapevine.Posts.show_all()
   {:ok, assign(socket, posts: posts)}
  end


end
