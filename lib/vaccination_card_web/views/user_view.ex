defmodule VaccinationCardWeb.UserView do
  use VaccinationCardWeb, :view

  def render("account.json", %{user: user, account: account}) do
    %{
      vaccine_card: account.vaccine_card,
      account_id: account.id,
      user: %{
        email: user.email,
        first_name: user.first_name,
        last_name: user.last_name,
        age: user.age,
        sex: user.sex,
        role: user.role,
        id: user.id
      }
    }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("user_auth.json", %{user: user, token: token}) do
    user = Map.put(render_one(user, __MODULE__, "user.json"), :token, token)
    %{data: user}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      role: user.role,
      accounts: %{
        id: user.accounts.id,
        vaccine_card: user.accounts.vaccine_card
      }
    }
  end
end
