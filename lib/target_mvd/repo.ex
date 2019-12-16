defmodule TargetMvd.Repo do
  use Ecto.Repo,
    otp_app: :target_mvd,
    adapter: Ecto.Adapters.Postgres
end
