defmodule VaccinationCard.Accounts.Auth.Pipeline do
  @moduledoc """
    A guardian pipeline for a jwt authenticate
  """

  use Guardian.Plug.Pipeline,
    otp_app: :vaccination_card,
    module: VaccinationCard.Accounts.Auth.Guardian,
    error_handler: VaccinationCard.Accounts.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
