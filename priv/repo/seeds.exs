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
alias Grapevine.Posts
alias Grapevine.Accounts.User
alias Grapevine.Like
alias Grapevine.Post

#############################################
# USERS ATTRS
# ##########################################

# user attrs
user_attrs = [
  %{email: "user.elixir@example.com", password: "passwordpass"},
  %{email: "user.ruby@example.com", password: "passwordpass"}
]

# fetch user email
user_emails = Enum.map(user_attrs, &Map.get(&1, :email))

#############################################
# DELETES
# ##########################################
(l in Like)
|> Ecto.Query.from(join: u in User, on: u.id == l.user_id, where: u.email in ^user_emails)
|> Repo.delete_all()

(p in Post)
|> Ecto.Query.from(join: u in User, on: u.id == p.user_id, where: u.email in ^user_emails)
|> Repo.delete_all()

(u in User)
|> Ecto.Query.from(where: u.email in ^user_emails)
|> Repo.delete_all()

#############################################
# USERS
# ##########################################
[first_user, last_user] =
  user_attrs
  |> Enum.map(fn attrs ->
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end)

#############################################
# POSTS
# ##########################################

# function to create days ago
days_ago = fn days ->
  seconds = -(days * 24 * 3600)

  NaiveDateTime.utc_now()
  |> NaiveDateTime.add(seconds, :second)
  |> NaiveDateTime.truncate(:second)
end

# post attrs
post_attrs = [
  %{
    title: "Programming Phoenix LiveView - Book",
    content: "https://pragprog.com/titles/liveview/programming-phoenix-liveview/",
    user_id: first_user.id,
    inserted_at: days_ago.(35),
    updated_at: days_ago.(35)
  },
  %{
    title: "Designing Elixir Systems with OTP - Book",
    content: "https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/",
    user_id: first_user.id,
    inserted_at: days_ago.(30),
    updated_at: days_ago.(30)
  },
  %{
    title: "Programming Phoenix 1.4 - Book",
    content: "https://pragprog.com/titles/phoenix14/programming-phoenix-1-4/",
    user_id: first_user.id,
    inserted_at: days_ago.(20),
    updated_at: days_ago.(20)
  },
  %{
    title: "Agile Web Development with Rails 6 - Book",
    content: "https://pragprog.com/titles/rails6/agile-web-development-with-rails-6/",
    user_id: last_user.id,
    inserted_at: days_ago.(15),
    updated_at: days_ago.(15)
  },
  %{
    title: "Docker for Rails Developers - Book",
    content: "https://pragprog.com/titles/ridocker/docker-for-rails-developers/",
    user_id: last_user.id,
    inserted_at: days_ago.(10),
    updated_at: days_ago.(10)
  },
  %{
    title: "Rails 5 Test Prescription - Book",
    content: "https://pragprog.com/titles/nrtest3/rails-5-test-prescriptions/",
    user_id: last_user.id,
    inserted_at: days_ago.(5),
    updated_at: days_ago.(5)
  }
]

# create posts
Repo.insert_all(Post, post_attrs)

#############################################
# LIKES
# ##########################################
(p in Post)
|> Ecto.Query.from(
  join: u in User,
  on: u.id == p.user_id,
  where: u.email in ^user_emails,
  select: %{post_id: p.id, user_id: p.user_id}
)
|> Repo.all()
|> Enum.map(&Posts.like/1)
