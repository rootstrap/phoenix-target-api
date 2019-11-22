defmodule TargetWeb.API.V1.ConfirmationControllerTest do
  use TargetWeb.ConnCase

  @valid_credentials %{
    "email" => "test@example.com",
    "password" => "secret1234",
    "confirm_password" => "secret1234"
  }
  @pow_config [otp_app: :target]

  setup %{conn: conn} do
    user =
      @valid_credentials
      |> Pow.Operations.create(@pow_config)
      |> elem(1)

    {:ok, conn: conn, user: user}
  end

  describe "show/2" do
    test "with a valid email confirmation token", %{conn: conn, user: user} do
      conn =
        get(conn, Routes.api_v1_confirmation_path(conn, :show, user.email_confirmation_token))

      assert redirected_to(conn, 302) == "https://confirmed-email-url/"
    end

    test "with an invalid email confirmation token", %{conn: conn} do
      conn = get(conn, Routes.api_v1_confirmation_path(conn, :show, "not-a-valid-token"))

      assert redirected_to(conn, 302) == "https://not-confirmed-email-url/"
    end
  end
end
