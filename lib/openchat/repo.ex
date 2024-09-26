defmodule Buzz.Repo do
  use Ecto.Repo,
    otp_app: :buzz,
    adapter: Ecto.Adapters.Postgres
end
