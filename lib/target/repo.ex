defmodule Target.Repo do
  use Ecto.Repo,
    otp_app: :target,
    adapter: Ecto.Adapters.Postgres
end
