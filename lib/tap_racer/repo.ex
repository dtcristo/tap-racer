defmodule TapRacer.Repo do
  use Ecto.Repo,
    otp_app: :tap_racer,
    adapter: Ecto.Adapters.Postgres
end
