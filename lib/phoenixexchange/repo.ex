defmodule Phoenixexchange.Repo do
  use Ecto.Repo,
    otp_app: :phoenixexchange,
    adapter: Ecto.Adapters.Postgres
end

