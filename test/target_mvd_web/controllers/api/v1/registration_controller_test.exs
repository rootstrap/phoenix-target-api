defmodule TargetMvdWeb.API.V1.RegistrationControllerTest do
  use ExUnit.Case
  use TargetMvdWeb.ConnCase

  alias TargetMvd.Repo
  alias TargetMvd.Users.User

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

    test "with valid params creates an user", %{conn: conn} do
      conn = post(conn, Routes.api_v1_registration_path(conn, :create, @valid_params))

      %User{id: user_id, email: user_email} =
        User
        |> Repo.all()
        |> List.first()

      assert json = json_response(conn, 200)
      assert %{"user" => %{"id" => ^user_id, "email" => ^user_email}} = json
    end

    test "with valid params sends a message (instead of an email) with the email confirmation token",
         %{conn: conn} do
      post(conn, Routes.api_v1_registration_path(conn, :create, @valid_params))

      user =
        User
        |> Repo.all()
        |> List.first()

      assert_received {:ok, email_confirmation_token}
      assert email_confirmation_token = user.email_confirmation_token
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
