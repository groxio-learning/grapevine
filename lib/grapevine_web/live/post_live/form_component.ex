defmodule PostLive.FormComponent do
  # If you generated an app with mix phx.new --live,
  # the line below would be: use MyAppWeb, :live_component
  use GrapevineWeb, :live_component

  def update(assigns, socket) do

    changeset = Grapevine.Posts.post_changeset()
    {:ok, socket
          |> assign(assigns)
          |> assign(:changeset, changeset)}
  end
end
