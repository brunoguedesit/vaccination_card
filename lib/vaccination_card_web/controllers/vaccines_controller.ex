defmodule VaccinationCardWeb.VaccinesController do
  use VaccinationCardWeb, :controller
  alias VaccinationCard.Operations.Vaccination
  alias VaccinationCard.Repo
  alias VaccinationCard.Accounts

  plug :verify_permission when action in [:register_vaccine, :delete_vaccine]

  def vaccine_card(conn, _) do
    user = Guardian.Plug.current_resource(conn)
    account = Accounts.get!(user.accounts.id) |> Repo.preload(:vaccine_card)
    vaccine_card = Vaccination.get_vaccine_card!(account.vaccine_card.id)

    conn
    |> render("vaccine_card.json", %{vaccine_card: vaccine_card})
  end

  def take_dose(conn, params) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, vaccine} <- Vaccination.take_dose(user, params) do
      conn
      |> render("success.json", %{vaccine: vaccine})
    else
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(VaccinationCardWeb.ErrorView, "error_message.json", message: reason)
    end
  end

  def register_vaccine(conn, params) do
    with {:ok, _message} <- Vaccination.register_vaccine(params) do
      conn
      |> send_resp(:created, "Vaccine has registered with success")
    else
      {:error, _reason} ->
        send_resp(conn, :unprocessable_entity, "There is an vaccine with this name")
    end
  end

  def delete_vaccine(conn, params) do
    with :ok <- Vaccination.delete_vaccine(params) do
      send_resp(conn, :no_content, "")
    else
      {:error, :not_found} ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Vaccine not found"})

      {:error, :forbidden} ->
        conn
        |> put_status(:forbidden)
        |> json(%{error: "Forbidden"})
    end
  end

  def vaccine_types(conn, _) do
    vaccine_types = Vaccination.get_all_vaccine_types()

    conn
    |> render("get_all_vaccine_types.json", %{vaccine_types: vaccine_types})
  end

  defp verify_permission(conn, _) do
    user = Guardian.Plug.current_resource(conn)

    if user.role == "admin" do
      conn
    else
      conn
      |> put_status(401)
      |> json(%{error: "unauthorized"})
    end
  end
end
