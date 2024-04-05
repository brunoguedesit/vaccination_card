defmodule VaccinationCard.Accounts.VaccineType do
  use Ecto.Schema

  @primary_key {:id, :integer, []}
  @foreign_key_type Ecto.UUID

  schema "vaccine_types" do
    field :name, :string

    has_many :vaccines, VaccinationCard.Accounts.Vaccine
  end

  def changeset(vaccine_type, params \\ %{}) do
    vaccine_type
    |> Ecto.Changeset.cast(params, [:name, :id])
    |> Ecto.Changeset.validate_required([:name])
  end
end
