defmodule VaccinationCard.Accounts do
  alias VaccinationCard.Repo
  alias VaccinationCard.Accounts.{Account, User, VaccineCard}

  require Logger

  def create_user(params \\ %{}) do
    transaction =
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:user, insert_user(params))
      |> Ecto.Multi.insert(:account, fn %{user: user} ->
        user
        |> Ecto.build_assoc(:accounts)
        |> Account.changeset()
      end)
      |> Ecto.Multi.insert(:vaccine_card, fn %{account: account} ->
        account = Repo.preload(account, :user)

        vaccination_card_params = %{
          full_name: "#{account.user.first_name} #{account.user.last_name}",
          age: account.user.age,
          sex: account.user.sex
        }

        account
        |> Ecto.build_assoc(:vaccine_card, vaccination_card_params)
        |> VaccineCard.changeset()
      end)
      |> Repo.transaction()

    case transaction do
      {:ok, %{user: user, vaccine_card: vaccine_card, account: account}} ->
        account_id = UUID.string_to_binary!(account.id)
        vaccine_card_is = UUID.string_to_binary!(vaccine_card.id)

        case Ecto.Adapters.SQL.query(
               Repo,
               "UPDATE accounts SET vaccine_card_id = $1 WHERE id = $2",
               [vaccine_card_is, account_id]
             ) do
          {:ok, _} ->
            Logger.info("Vaccine card registered with sucesss")

          {:error, _} ->
            Logger.info("Vaccine card registered had failed")
        end

        {:ok, user, account, vaccine_card}

      {:error, _kind, changeset, _} ->
        {:error, changeset}
    end
  end

  defp insert_user(params) do
    %User{}
    |> User.changeset(params)
  end

  def get_user!(id), do: Repo.get(User, id) |> Repo.preload(:accounts)

  def get_users, do: Repo.all(User) |> Repo.preload(:accounts)

  def get!(id), do: Repo.get(Account, id)
end
