# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     VaccinationCard.Repo.insert!(%VaccinationCard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

import Ecto.Query
alias VaccinationCard.Repo
import VaccinationCard.Accounts.VaccineType

# Lista de todas as vacinas que deseja inserir
vaccine_types = [
  %{name: "BCG"},
  %{name: "HEPATITE A"},
  %{name: "HEPATITE B"},
  %{name: "ANTI-POLIO(SABIN)"},
  %{name: "TETRA VALENTE"},
  %{name: "TRICIPE BACTERIANA (OPT)"},
  %{name: "HAEMOPHILUS INFLUENZAE"},
  %{name: "TRIPLICE ACELULAR"},
  %{name: "PNEUMO 10 VALENTE"},
  %{name: "MENINGO C"},
  %{name: "ROTAVIRUS"},
  %{name: "COVID-19"}
]

# Insira as vacinas na tabela vaccine_types
Repo.insert_all(VaccinationCard.Accounts.VaccineType, vaccine_types)
