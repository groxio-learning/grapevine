defmodule Grapevine.PostsTest do
  use Grapevine.DataCase
  import Grapevine.AccountsFixtures
  alias Grapevine.Post
  alias Grapevine.Posts

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
end
