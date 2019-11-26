defmodule TargetWeb.API.V1.TopicControllerTest do
  use TargetWeb.ConnCase

  alias Target.Targets
  alias Target.Targets.Topic
  alias TargetWeb.APIAuthPlug

  @pow_config [otp_app: :target]
  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  def fixture(:topic) do
    {:ok, topic} = Targets.create_topic(@create_attrs)
    topic
  end

  setup %{conn: conn} do
    %{conn: conn, user_token: user_token} = create_user(conn)

    conn =
      conn
      |> put_req_header("authorization", user_token)
      |> put_req_header("accept", "application/json")

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all topics", %{conn: conn} do
      conn = get(conn, Routes.api_v1_topic_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create topic" do
    test "renders topic when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_topic_path(conn, :create), topic: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_topic_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_topic_path(conn, :create), topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update topic" do
    setup [:create_topic]

    test "renders topic when data is valid", %{conn: conn, topic: %Topic{id: id} = topic} do
      conn = put(conn, Routes.api_v1_topic_path(conn, :update, topic), topic: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.api_v1_topic_path(conn, :show, id))

      assert %{
               "id" => id,
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, topic: topic} do
      conn = put(conn, Routes.api_v1_topic_path(conn, :update, topic), topic: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete topic" do
    setup [:create_topic]

    test "deletes chosen topic", %{conn: conn, topic: topic} do
      conn = delete(conn, Routes.api_v1_topic_path(conn, :delete, topic))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_topic_path(conn, :show, topic))
      end
    end
  end

  defp create_topic(_) do
    topic = fixture(:topic)
    {:ok, topic: topic}
  end

  defp create_user(conn) do
    user =
      %{
        "email" => "test_topic@example.com",
        "password" => "secret1234",
        "confirm_password" => "secret1234"
      }
      |> Pow.Operations.create(@pow_config)
      |> elem(1)
      |> PowEmailConfirmation.Ecto.Context.confirm_email(@pow_config)
      |> elem(1)

    {authed_conn, _user} = APIAuthPlug.create(conn, user, @pow_config)

    %{conn: conn, user_token: authed_conn.private[:api_auth_token]}
  end
end
