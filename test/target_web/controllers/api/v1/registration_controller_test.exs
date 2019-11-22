defmodule TargetWeb.API.V1.RegistrationControllerTest do
  use ExUnit.Case
  use Bamboo.Test
  use TargetWeb.ConnCase

  alias Target.Repo
  alias Target.Users.User

  describe "create/2" do
    @valid_params %{
      "user" => %{
        "email" => "test@example.com",
        "password" => "secret1234",
        "confirm_password" => "secret1234",
        "gender" => "other"
      }
    }
    @invalid_params %{
      "user" => %{
        "email" => "invalid",
        "password" => "secret1234",
        "confirm_password" => "",
        "gender" => "invalid"
      }
    }

    test "with valid params", %{conn: conn} do
      conn = post(conn, Routes.api_v1_registration_path(conn, :create, @valid_params))

      user =
        User
        |> Repo.all()
        |> List.first()

      assert json = json_response(conn, 200)
      assert json["data"]["token"]
      assert json["data"]["renew_token"]
      assert_received {:ok, token}
      assert token = user.email_confirmation_token
    end

    test "with invalid params", %{conn: conn} do
      conn = post(conn, Routes.api_v1_registration_path(conn, :create, @invalid_params))

      assert json = json_response(conn, 422)

      assert json["error"]["message"] == "Couldn't create user"
      assert json["error"]["status"] == 422
      assert json["error"]["errors"]["confirm_password"] == ["not same as password"]
      assert json["error"]["errors"]["email"] == ["has invalid format"]
      assert json["error"]["errors"]["gender"] == ["is invalid"]
    end
  end
end
