defmodule VaccinationCardWeb.VaccinesView do
  use VaccinationCardWeb, :view

  def render("vaccine_card.json", %{vaccine_card: vaccine_card}) do
    %{
      id: vaccine_card.id,
      full_name: vaccine_card.full_name,
      age: vaccine_card.age,
      sex: vaccine_card.sex,
      vaccines: vaccine_card.vaccines
    }
  end

  def render("get_all_vaccine_types.json", %{vaccine_types: vaccine_types}) do
    %{json: render_vaccine_types(vaccine_types)}
  end

  def render("success.json", %{vaccine: _vaccine}) do
    %{
      message: "Vaccine had been taken"
    }
  end

  def render("register_vaccine.json", %{message: _message}) do
    %{message: "Vaccine has been registered"}
  end

  defp render_vaccine_types(vaccine_types) do
    Enum.map(vaccine_types, &render_vaccine_type/1)
  end

  defp render_vaccine_type(vaccine_type) do
    %{
      id: vaccine_type.id,
      name: vaccine_type.name
    }
  end
end
