defmodule VaccinationCard.Repo.Migrations.CreateVaccinationCard do
  use Ecto.Migration

  def change do
    create table(:vaccine_cards, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :full_name, :string
      add :age, :integer
      add :sex, :string
      add :account_id, references(:accounts, type: :uuid, on_delete: :delete_all)

      timestamps()
    end
  end
end
