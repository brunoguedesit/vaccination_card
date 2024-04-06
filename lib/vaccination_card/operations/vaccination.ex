defmodule VaccinationCard.Operations.Vaccination do
  alias VaccinationCard.Accounts.{User, Vaccine, VaccineCard, VaccineType}
  alias VaccinationCard.Repo

  import Ecto.Query
  require Logger

  def get_vaccine_card!(id) do
    Repo.get(VaccineCard, id) |> Repo.preload(:vaccines)
  end

  @spec get_all_vaccine_types() :: any()
  def get_all_vaccine_types(), do: Repo.all(VaccineType)

  def register_vaccine(params) do
    with {:ok, _} <- insert_vaccine_type(params) do
      {:ok, "Vaccine created successfully."}
    else
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp insert_vaccine_type(params) do
    name = String.upcase(params["VaccineType"]["name"])
    body = %{name: name}

    %VaccinationCard.Accounts.VaccineType{}
    |> VaccineType.changeset(body)
    |> Repo.insert()
  end

  def delete_vaccine(params) do
    id = params["VaccineType"]["id"]
    name = String.upcase(params["VaccineType"]["name"])

    case Repo.get_by(VaccineType, id: id, name: name) do
      nil ->
        {:error, :not_found}

      vaccine ->
        case Repo.delete(vaccine) do
          {:ok, _} ->
            :ok

          _ ->
            {:error, :forbidden}
        end
    end
  end

  def take_dose(user, params) do
    user = Repo.get(User, user.id) |> Repo.preload(accounts: :vaccine_card)

    with :ok <- validate_vaccine(params["Vaccines"]["vaccine_type_id"]),
         :ok <-
           validate_dose(
             params["Vaccines"]["dose_number"],
             params["Vaccines"]["vaccine_type_id"],
             user.accounts.vaccine_card.id
           ),
         {:ok, vaccine} <- insert_vaccine(user, params) do
      {:ok, vaccine}
    else
      {:error, reason} ->
        {:error, reason}
    end
  end

  defp validate_vaccine(vaccine_type_id) do
    Repo.get(VaccineType, vaccine_type_id)
    |> case do
      nil ->
        Logger.info("Vaccine type id does not exist in our system")
        {:error, "Vaccine type id does not exist"}

      _vaccine_type ->
        :ok
    end
  end

  defp validate_dose(1, vaccine_type_id, vaccine_card_id) do
    case Repo.all(
           from v in Vaccine,
             join: vt in assoc(v, :vaccine_type),
             where:
               v.dose_number == 1 and v.vaccine_card_id == ^vaccine_card_id and
                 vt.id == ^vaccine_type_id
         ) do
      [] ->
        :ok

      _ ->
        vaccine_type_name = Repo.get!(VaccineType, vaccine_type_id).name

        {:error,
         "The first dose of type #{vaccine_type_name} has already been registered for this vaccine card."}
    end
  end

  defp validate_dose(dose_number, vaccine_type_id, vaccine_card_id) when dose_number in 2..5 do
    prev_dose_number = dose_number - 1

    case check_previous_dose(prev_dose_number, vaccine_type_id, vaccine_card_id) do
      {:ok, _} ->
        case dose_number do
          5 ->
            {:error, "Vaccination for this type is complete."}

          _ ->
            case Repo.exists?(
                   from v in Vaccine,
                     join: vt in assoc(v, :vaccine_type),
                     where:
                       v.dose_number == ^dose_number and
                         v.vaccine_card_id == ^vaccine_card_id and
                         vt.id == ^vaccine_type_id
                 ) do
              true ->
                {:error,
                 "A dose number #{dose_number} of this type has already been registered for this vaccine card."}

              false ->
                :ok
            end
        end

      {:error, message} ->
        {:error, message}
    end
  end

  defp validate_dose(dose_number, _vaccine_type_id, _vaccine_card_id) when dose_number > 5 do
    {:error, "Invalid dose number: #{dose_number}. Dose number must be between 1 and 5."}
  end

  defp check_previous_dose(prev_dose_number, vaccine_type_id, vaccine_card_id) do
    case Repo.exists?(
           from v in Vaccine,
             join: vt in assoc(v, :vaccine_type),
             where:
               v.dose_number == ^prev_dose_number and
                 v.vaccine_card_id == ^vaccine_card_id and
                 vt.id == ^vaccine_type_id
         ) do
      true ->
        {:error,
         "A dose number #{prev_dose_number} of this type has already been registered for this vaccine card."}

      false ->
        {:error,
         "A dose number #{prev_dose_number} of this type has not been registered for this vaccine card yet."}
    end
  end

  defp insert_vaccine(user, params) do
    vaccine_card_id = user.accounts.vaccine_card.id

    body = %{
      dose_number: params["Vaccines"]["dose_number"],
      vaccine_type_id: params["Vaccines"]["vaccine_type_id"],
      booster: validate_booster_field(params["Vaccines"]["dose_number"]),
      date_administered: NaiveDateTime.utc_now(),
      vaccine_card_id: vaccine_card_id
    }

    %VaccinationCard.Accounts.Vaccine{}
    |> Ecto.Changeset.cast(body, [
      :dose_number,
      :vaccine_type_id,
      :vaccine_card_id,
      :booster,
      :date_administered
    ])
    |> Repo.insert()
  end

  defp validate_booster_field(dose_number) do
    case dose_number do
      5 -> true
      4 -> true
      _ -> false
    end
  end
end
