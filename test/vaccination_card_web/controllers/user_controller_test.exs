defmodule VaccinationCardWeb.UserControllerTest do
  use VaccinationCardWeb.ConnCase
  use ExUnit.Case, async: true

  alias VaccinationCard.Accounts.{User, Account}
  alias VaccinationCard.Accounts
  alias VaccinationCard.Repo
  import VaccinationCard.Accounts.Auth.Guardian


  @invalid_params %{
    email: FakerElixir.Internet.email("teste"),
    first_name: "user",
    last_name: "test 1",
    age: 20,
    sex: "male",
    password: "test123",
    password_confirmation: "321"
  }

  @accounts_params %{
    user_id: nil
  }

  @vaccine_card_params %{
    full_name: nil,
    age: nil,
    sex: nil,
    account_Id: nil
  }

  # def create_user(:user) do
  #   {:ok, %{"user" => user}} = Accounts.create_user(@user_params)
  # end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "user_auth" do
    test "when all params are valid, returns an user account created with vaccine_card", %{conn: conn} do

      user_id = Ecto.UUID.generate()
  account_id = Ecto.UUID.generate()
  vaccine_card_id = Ecto.UUID.generate()

      user_params = %{
        "id" => user_id,
        "age" => 20,
        "email" => FakerElixir.Internet.email("teste"),
        "first_name" => "user",
        "last_name" => "test 1",
        "password" => "test123",
        "password_confirmation" => "test123",
        "sex" => "male"
      }

      account_params = %{
        "user_id" => user_id
      }

      vaccine_card_params = %{
        "account_id" => account_id
      }

      result_conn =
        conn
        |> post(Routes.user_path(conn, :signup), %{
           user: user_params,
           vaccine_card: vaccine_card_params,
           account: account_params
         })

      assert %{"id" => user_id, "first_name" => "user"} = json_response(result_conn, 201)["user"]
    end

    test "when there params are invalid, returns an error", %{conn: conn} do
      user = @invalid_params

      conn = post(conn, Routes.user_path(conn, :signup), user: user)
      assert json_response(conn, 422)["errors"] != %{}
    end

    test "when all params are valid, returns an successfully authentication", %{conn: conn} do
      user_id = Ecto.UUID.generate()
  account_id = Ecto.UUID.generate()
  vaccine_card_id = Ecto.UUID.generate()

      user_params = %{
        "age" => 20,
        "email" => "test@test.com",
        "first_name" => "user",
        "last_name" => "test 1",
        "password" => "test123",
        "password_confirmation" => "test123",
        "sex" => "male"
      }

      account_params = %{
        "user_id" => user_id
      }

      vaccine_card_params = %{
        "account_id" => account_id
      }


        conn
        |> post(Routes.user_path(conn, :signup), %{
           user: user_params,
           vaccine_card: vaccine_card_params,
           account: account_params
         })

      conn = post(conn, Routes.user_path(conn, :signin), email: user_params["email"], password: "test123")
      result = json_response(conn, 201)

      assert "test@test.com" == result["data"]["email"]
      assert "user test 1" == result["data"]["accounts"]["vaccine_card"]["full_name"]
    end
  end
end
