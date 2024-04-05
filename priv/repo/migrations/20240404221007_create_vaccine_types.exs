defmodule VaccinationCard.Repo.Migrations.CreateVaccineTypes do
  use Ecto.Migration

  def change do
    create table(:vaccine_types, primary_key: false) do
      add :id, :serial, primary_key: true
      add :name, :string
    end

    create unique_index(:vaccine_types, [:name])
  end
end
