defmodule VaccinationCardWeb.Router do
  use VaccinationCardWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug VaccinationCard.Accounts.Auth.Pipeline
  end

  scope "/api/auth", VaccinationCardWeb do
    post "/signup", UserController, :signup
    post "/signin", UserController, :signin
  end

  scope "/api", VaccinationCardWeb do
    pipe_through [:api, :auth]

    get "/vaccine_card", VaccinesController, :vaccine_card
    get "/vaccine_types", VaccinesController, :vaccine_types

    post "/vaccines/take-dose", VaccinesController, :take_dose
    post "/vaccines/register", VaccinesController, :register_vaccine

    delete "/vaccines/delete", VaccinesController, :delete_vaccine
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:vaccination_card, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: VaccinationCardWeb.Telemetry
    end
  end
end
