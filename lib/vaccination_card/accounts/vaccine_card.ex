defmodule VaccinationCard.Accounts.VaccineCard do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  @derive {Jason.Encoder, only: [:full_name, :age, :sex]}
  schema "vaccine_cards" do
    field :full_name, :string
    field :age, :integer
    field :sex, :string
    has_many :vaccines, VaccinationCard.Accounts.Vaccine
    belongs_to :account, VaccinationCard.Accounts.Account

    timestamps()
  end

  def changeset(vaccine_card, params \\ %{}) do
    vaccine_card
    |> cast(params, [:full_name, :age, :sex])
    |> validate_required([:full_name, :age, :sex])
    |> cast_assoc(:vaccines, with: &VaccinationCard.Accounts.Vaccine.changeset/2)
    |> assoc_constraint(:account)
  end
end
