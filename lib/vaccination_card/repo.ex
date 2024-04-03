defmodule VaccinationCard.Repo do
  use Ecto.Repo,
    otp_app: :vaccination_card,
    adapter: Ecto.Adapters.Postgres
end
