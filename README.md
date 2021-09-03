# Grapevine

### setup

Create a file `dev.secret.exs` and `test.secret.exs` into `config` folder. The dummy file:

```elixir
use Mix.Config

config :grapevine, Grapevine.Repo,
  username: "postgres",
  password: "postgres",
  database: "grapevine_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

And update the values for `username`, `password`, `hostname`.

Setup the project with `mix setup`.

Start Phoenix endpoint with `mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### Dummy Data

Add instructions into `priv/repo/seeds.exs` to delete dummy users and posts and create all dummy users and posts, when its run `mix run priv/repo/seeds.exs` or `mix setup`.

| e-mail                  | password     |
| ----------------------- | ------------ |
| user.elixir@example.com | passwordpass |
| user.ruby@example.com   | passwordpass |
