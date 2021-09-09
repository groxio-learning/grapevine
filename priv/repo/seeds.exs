# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Grapevine.Repo.insert!(%Grapevine.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

require Ecto.Query

alias Grapevine.Repo
alias Grapevine.Accounts.User
alias Grapevine.Post

#############################################
# USERS
# ##########################################

# user attrs
user_attrs = [
  %{email: "user.elixir@example.com", password: "passwordpass"},
  %{email: "user.ruby@example.com", password: "passwordpass"}
]

# fetch user email
user_emails = Enum.map(user_attrs, &Map.get(&1, :email))

# delete users
(u in User)
|> Ecto.Query.from(where: u.email in ^user_emails)
|> Repo.delete_all()

# create users
created_users =
  user_attrs
  |> Enum.map(fn attrs ->
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end)

#############################################
# POSTS
# ##########################################

# split users
[first_user, last_user] = created_users

# post attrs
post_attrs = [
  %{
    title: "Programming Phoenix LiveView - Book",
    content: "https://pragprog.com/titles/liveview/programming-phoenix-liveview/",
    user_id: first_user.id
  },
  %{
    title: "Designing Elixir Systems with OTP - Book",
    content: "https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/",
    user_id: first_user.id
  },
  %{
    title: "Programming Phoenix 1.4 - Book",
    content: "https://pragprog.com/titles/phoenix14/programming-phoenix-1-4/",
    user_id: first_user.id
  },
  %{
    title: "Agile Web Development with Rails 6 - Book",
    content: "https://pragprog.com/titles/rails6/agile-web-development-with-rails-6/",
    user_id: last_user.id
  },
  %{
    title: "Docker for Rails Developers - Book",
    content: "https://pragprog.com/titles/ridocker/docker-for-rails-developers/",
    user_id: last_user.id
  },
  %{
    title: "Rails 5 Test Prescription - Book",
    content: "https://pragprog.com/titles/nrtest3/rails-5-test-prescriptions/",
    user_id: last_user.id
  }
]

# fetch post title
post_titles = Enum.map(post_attrs, &Map.get(&1, :title))

# delete posts
(p in Post)
|> Ecto.Query.from(where: p.title in ^post_titles)
|> Repo.delete_all()

# create posts
_created_posts =
  post_attrs
  |> Enum.map(fn attrs ->
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert!()
  end)
