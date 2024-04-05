defmodule VaccinationCard.Accounts.Account do
  @moduledoc """
    Account schema
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID

  @derive Jason.Encoder
  schema "accounts" do
    has_one :vaccine_card, VaccinationCard.Accounts.VaccineCard
    belongs_to :user, VaccinationCard.Accounts.User

    timestamps()
  end

  def changeset(account, params \\ %{}) do
    account
    |> cast(params, [])
    |> cast_assoc(:vaccine_card, required: false)
    |> validate_required([])
  end
end
