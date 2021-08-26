defmodule PostLive.FormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use GrapevineWeb, :live_component

  def update(assigns, socket) do
    changeset = Grapevine.Posts.post_changeset(assigns)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, %{assigns: %{post: _}} = socket) do
    Grapevine.Posts.update(socket.assigns.changeset, post_params)
    {:noreply, push_redirect(socket, to: "/posts")}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    Grapevine.Posts.create(post_params, socket.assigns.current_user.id)
    {:noreply, push_redirect(socket, to: "/posts")}
  end
end
