defmodule GrapevineWeb.CategoriesDropdown do
  use GrapevineWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= f=form_for :category_filter, "#", [phx_target: @myself, phx_change: "category_filter"] %>
        Category: <%= select f, :category_id, Enum.map(@categories, &{&1.name, &1.id}), selected: @category_id %>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  def handle_event(
        "category_filter",
        %{"category_filter" => %{"category_id" => category_id}},
        socket
      ) do
    {:noreply, push_patch(socket, to: "/posts?category_id=#{category_id}")}
  end
end
