defmodule TargetWeb.API.V1.SessionControllerTest do
  use TargetWeb.ConnCase

  alias TargetWeb.APIAuthPlug

  @pow_config [otp_app: :target]

  describe "create/2" do
    @valid_credentials %{"email" => "test@example.com", "password" => "secret1234"}
    @valid_params %{"user" => @valid_credentials}
    @invalid_params %{"user" => %{"email" => "test@example.com", "password" => "invalid"}}

    test "with valid params and confirmed email", %{conn: conn} do
      create_user(@valid_credentials, :confirmed)
      conn = post(conn, Routes.api_v1_session_path(conn, :create, @valid_params))

      assert json = json_response(conn, 200)
      assert json["data"]["token"]
      assert json["data"]["renew_token"]
    end

    test "with valid params and unconfirmed email", %{conn: conn} do
      create_user(@valid_credentials, :unconfirmed)
      conn = post(conn, Routes.api_v1_session_path(conn, :create, @valid_params))

      assert json = json_response(conn, 403)
      assert json["error"]["message"] == "You must confirm your email address before logging in."
      assert json["error"]["status"] == 403
    end

    test "with invalid params", %{conn: conn} do
      create_user(@valid_credentials, :confirmed)
      conn = post(conn, Routes.api_v1_session_path(conn, :create, @invalid_params))

      assert json = json_response(conn, 401)
      assert json["error"]["message"] == "Invalid email or password"
      assert json["error"]["status"] == 401
    end
  end

  describe "renew/2" do
    setup %{conn: conn} do
      user =
        @valid_credentials
        |> create_user(:confirmed)
        |> elem(1)

      {authed_conn, _user} = APIAuthPlug.create(conn, user, @pow_config)

      :timer.sleep(100)

      {:ok, conn: conn, renew_token: authed_conn.private[:api_renew_token]}
    end

    test "with valid authorization header", %{conn: conn, renew_token: token} do
      conn =
        conn
        |> Plug.Conn.put_req_header("authorization", token)
        |> post(Routes.api_v1_session_path(conn, :renew))

      assert json = json_response(conn, 200)
      assert json["data"]["token"]
      assert json["data"]["renew_token"]
    end

    test "with invalid authorization header", %{conn: conn} do
      conn =
        conn
        |> Plug.Conn.put_req_header("authorization", "invalid")
        |> post(Routes.api_v1_session_path(conn, :renew))

      assert json = json_response(conn, 401)

      assert json["error"]["message"] == "Invalid token"
      assert json["error"]["status"] == 401
    end
  end

  describe "delete/2" do
    setup %{conn: conn} do
      user =
        @valid_credentials
        |> create_user(:confirmed)
        |> elem(1)

      {authed_conn, _user} = APIAuthPlug.create(conn, user, @pow_config)

      :timer.sleep(100)

      {:ok, conn: conn, auth_token: authed_conn.private[:api_auth_token]}
    end

    test "invalidates", %{conn: conn, auth_token: token} do
      conn =
        conn
        |> Plug.Conn.put_req_header("authorization", token)
        |> delete(Routes.api_v1_session_path(conn, :delete))

      assert json_response(conn, 200)
      :timer.sleep(100)

      assert {_conn, nil} = APIAuthPlug.fetch(conn, @pow_config)
    end
  end

  defp create_user(params, :confirmed) do
    params
    |> Map.merge(%{"confirm_password" => "secret1234"})
    |> Pow.Operations.create(@pow_config)
    |> elem(1)
    |> PowEmailConfirmation.Ecto.Context.confirm_email(@pow_config)
  end

  defp create_user(params, :unconfirmed) do
    params
    |> Map.merge(%{"confirm_password" => "secret1234"})
    |> Pow.Operations.create(@pow_config)
  end
end
