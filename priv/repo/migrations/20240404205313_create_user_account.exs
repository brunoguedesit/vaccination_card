defmodule VaccinationCard.Repo.Migrations.CreateUserAccount do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :user_id, references(:users, type: :uuid, on_delete: :delete_all)

      timestamps()
    end
  end
end
