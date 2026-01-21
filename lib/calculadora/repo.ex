defmodule Calculadora.Repo do
  use Ecto.Repo,
    otp_app: :calculadora,
    adapter: Ecto.Adapters.Postgres
end
