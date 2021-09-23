defmodule Grapevine.PostsTest do
  use Grapevine.DataCase
  import Grapevine.AccountsFixtures
  alias Grapevine.Post
  alias Grapevine.Posts

  describe "delete/1" do
    test "successfully deleted an existing post" do
      %{id: user_id} = user_fixture()

      {:ok, %Post{id: post_id}} =
        Posts.create(%{"title" => "my first post", "content" => "http://google.com"}, user_id)

      assert {:ok, %Post{id: ^post_id}} = Posts.delete!(post_id, user_id)
    end

    test "failure to delete a non-existent post" do
      %{id: id} = user_fixture()

      assert_raise Ecto.NoResultsError, fn ->
        Posts.delete!(0, id)
      end
    end
  end

  describe "update/2" do
    test "successfully updates an existing post" do
      %{id: id} = user_fixture()

      {:ok, post} =
        Posts.create(%{"title" => "my first post", "content" => "http://google.com"}, id)

      assert {
               :ok,
               %Post{
                 title: "second post"
               }
             } = Posts.update(post, %{title: "second post"})
    end
  end

  describe "create/2" do
    test "successfully creates a new post" do
      %{id: id} = user_fixture()

      assert {
               :ok,
               %Post{
                 content: "http://google.com",
                 title: "my first post",
                 user_id: ^id
               }
             } = Posts.create(%{"title" => "my first post", "content" => "http://google.com"}, id)
    end
  end

  test "get all posts" do
    %{id: id} = user_fixture()

    {:ok, post_one} =
      Posts.create(
        %{"title" => "my first post", "content" => "https://google.com", "user_id" => id},
        id
      )

    {:ok, post_two} =
      Posts.create(
        %{"title" => "the second one", "content" => "https://wikipedia.org", "user_id" => id},
        id
      )

    test_posts = [post_one.id, post_two.id]

    assert test_posts ==
             Posts.show_all()
             |> Enum.filter(fn post -> id == post.user_id end)
             |> Enum.map(fn post -> post.id end)
  end
end
