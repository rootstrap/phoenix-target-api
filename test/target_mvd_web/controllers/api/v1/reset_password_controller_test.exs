defmodule TargetMvdWeb.API.V1.ResetPasswordControllerTest do
  use ExUnit.Case
  use TargetMvdWeb.ConnCase

  alias TargetMvd.Fixtures
  alias TargetMvdWeb.Endpoint

  @valid_params %{
    user: %{
      password: "secret1234",
      confirm_password: "secret1234"
    }
  }

  describe "create/2" do
    # $$ moduletag?
    setup [:create_user]

    test "with a valid user email sends generated token", %{conn: conn, user: user} do
      conn =
        post(
          conn,
          Routes.api_v1_reset_password_path(conn, :create, %{"user" => %{"email" => user.email}})
        )

      assert json = json_response(conn, 200)
      assert json["detail"] == "An email has been sent with instructions to reset password."
    end

    test "with an invalid user email renders error", %{conn: conn} do
      conn =
        post(
          conn,
          Routes.api_v1_reset_password_path(conn, :create, %{
            "user" => %{"email" => "invalid-email"}
          })
        )

      assert json = json_response(conn, 422)
      assert json["error"]["message"] == "User doesn't exist"
    end
  end

  describe "update/2" do
    setup [:create_user]

    test "with a valid token, pwd and pwd confirm, updates the password", %{
      conn: conn,
      user: user
    } do
      post(
        conn,
        Routes.api_v1_reset_password_path(conn, :create, %{"user" => %{"email" => user.email}})
      )

      assert_received {:ok, reset_password_token}

      conn =
        build_conn()
        |> put_req_header("content-type", "application/json")
        |> put(
          Routes.api_v1_reset_password_path(Endpoint, :update, reset_password_token),
          Poison.encode!(@valid_params)
        )

      assert json = json_response(conn, 200)
      assert json["detail"] == "Password updated successfully."
      # $$ how to check if password was indeed updated?
    end

    test "with an invalid token renders error", %{conn: conn} do
      conn =
        conn
        |> put_req_header("content-type", "application/json")
        |> put(
          Routes.api_v1_reset_password_path(Endpoint, :update, "invalid-reset-token"),
          Poison.encode!(@valid_params)
        )

      assert json = json_response(conn, 422)
      assert json["error"]["message"] == "Invalid token"
    end
  end

  describe "show/2" do
    setup [:create_user]

    test "with a valid token renders ok", %{conn: conn, user: user} do
      post(
        conn,
        Routes.api_v1_reset_password_path(conn, :create, %{"user" => %{"email" => user.email}})
      )

      assert_received {:ok, reset_password_token}

      conn = get(conn, Routes.api_v1_reset_password_path(Endpoint, :show, reset_password_token))
      assert json = json_response(conn, 200)
      assert json == "ok"
    end
  end

  defp create_user(_) do
    user = Fixtures.user_fixture()
    {:ok, user: user}
  end
end
