defmodule Verdemind.Repo do
  use Ecto.Repo,
    otp_app: :verdemind,
    adapter: Ecto.Adapters.Postgres
end
