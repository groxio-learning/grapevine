defmodule Grapevine.Repo do
  use Ecto.Repo,
    otp_app: :grapevine,
    adapter: Ecto.Adapters.Postgres
end
