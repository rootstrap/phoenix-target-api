defmodule TargetWeb.API.V1.TopicControllerTest do
  use TargetWeb.ConnCase

  alias Target.Targets
  alias Target.Targets.Topic

  @create_attrs %{
    name: "some name"
  }
  @update_attrs %{
    name: "some updated name"
  }
  @invalid_attrs %{name: nil}

  describe "index" do
    @describetag :authenticated
    setup [:create_topic]

    test "lists all topics", %{conn: conn, topic: topic} do
      conn = get(conn, Routes.api_v1_topic_path(conn, :index))
      assert json_response(conn, 200)["data"] == [%{"id" => topic.id, "name" => topic.name}]
    end
  end

  describe "create topic" do
    @describetag :authenticated

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
    @describetag :authenticated
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
    @describetag :authenticated
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
    {:ok, topic} = Targets.create_topic(@create_attrs)
    {:ok, topic: topic}
  end
end
