defmodule VaccinationCard.Repo.Migrations.AddVaccinationCardsReferenceIntoAccountsTable do
  use Ecto.Migration

  def change do
    alter table(:accounts) do
      add :vaccine_card_id,
          references(:vaccine_cards, type: :uuid, on_delete: :delete_all)
    end
  end
end
