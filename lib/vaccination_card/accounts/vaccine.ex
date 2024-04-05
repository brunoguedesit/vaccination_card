defmodule VaccinationCard.Accounts.Vaccine do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}

  @required_fields [:dose_number, :vaccine_type_id, :vaccine_card_id]
  @optional_fields [:booster]

  @derive {Jason.Encoder,
           only: [:dose_number, :booster, :date_administered, :vaccine_type_id, :vaccine_card_id]}
  schema "vaccines" do
    field :dose_number, :integer
    field :booster, :boolean, default: false
    field :date_administered, :naive_datetime

    belongs_to :vaccine_type, VaccinationCard.Accounts.VaccineType, type: :id
    belongs_to :vaccine_card, VaccinationCard.Accounts.VaccineCard, type: Ecto.UUID

    timestamps()
  end

  def changeset(vaccine, params \\ %{}) do
    vaccine
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
