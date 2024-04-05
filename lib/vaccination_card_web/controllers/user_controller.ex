defmodule VaccinationCardWeb.UserController do
  alias VaccinationCard.Accounts.{Account, User}
  use VaccinationCardWeb, :controller

  alias VaccinationCard.Accounts
  alias VaccinationCard.Accounts.Auth.Guardian

  alias VaccinationCard.Repo

  def signup(conn, %{"user" => user}) do
    with {:ok, user, account, vaccination_card} <- Accounts.create_user(user) do
      account = Repo.get(Account, account.id) |> Repo.preload(:vaccine_card)

      conn
      |> put_status(:created)
      |> render("account.json", %{
        user: user,
        account: account,
        vaccination_card: vaccination_card
      })
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(VaccinationCardWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def signin(conn, %{"email" => email, "password" => password}) do
    with {:ok, user, token} <- Guardian.authenticate(email, password) do
      user = Repo.get(User, user.id) |> Repo.preload(accounts: :vaccine_card)

      conn
      |> put_status(:created)
      |> render("user_auth.json", user: user, token: token)
    end
  end
end
