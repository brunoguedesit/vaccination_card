defmodule VaccinationCard.Repo.Migrations.CreateVaccines do
  use Ecto.Migration

  def change do
    create table(:vaccines, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :dose_number, :integer
      add :date_administered, :naive_datetime
      add :booster, :boolean

      add :vaccine_card_id,
          references(:vaccine_cards, type: :uuid, on_delete: :delete_all)

      add :vaccine_type_id, references(:vaccine_types, on_delete: :nothing)

      timestamps()
    end
  end
end
