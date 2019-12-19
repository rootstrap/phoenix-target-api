defmodule TargetMvdWeb.API.V1.TargetControllerTest do
  use TargetMvdWeb.ConnCase

  @moduletag :authenticated

  alias TargetMvd.Fixtures

  @create_attrs %{
    latitude: 120.5,
    longitude: 120.5,
    radius: 42,
    title: "some title"
  }
  @invalid_attrs %{latitude: nil, longitude: nil, radius: nil, title: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_target]

    test "lists all user targets", %{conn: conn, target: target} do
      conn = get(conn, Routes.api_v1_target_path(conn, :index))

      assert json_response(conn, 200)["data"] == [
               %{
                 "id" => target.id,
                 "latitude" => target.latitude,
                 "longitude" => target.longitude,
                 "radius" => target.radius,
                 "title" => target.title
               }
             ]
    end
  end

  describe "show" do
    setup [:create_targets_list]

    test "shows user targets", %{conn: conn, target: target} do
      conn = get(conn, Routes.api_v1_target_path(conn, :show, target))

      assert json_response(conn, 200)["data"] ==
               %{
                 "id" => target.id,
                 "latitude" => target.latitude,
                 "longitude" => target.longitude,
                 "radius" => target.radius,
                 "title" => target.title
               }
    end

    test "doesn't show another user targets", %{conn: conn, another_target: target} do
      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_target_path(conn, :show, target))
      end
    end
  end

  describe "create target" do
    test "renders target when data is valid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_target_path(conn, :create), target: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.api_v1_target_path(conn, :show, id))

      assert %{
               "id" => id,
               "latitude" => 120.5,
               "longitude" => 120.5,
               "radius" => 42,
               "title" => "some title"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.api_v1_target_path(conn, :create), target: @invalid_attrs)

      assert json_response(conn, 422)["errors"] == %{
               "latitude" => ["can't be blank"],
               "longitude" => ["can't be blank"],
               "radius" => ["can't be blank"],
               "title" => ["can't be blank"]
             }
    end

    test "renders errors when target limit reached", %{conn: conn, user: user} do
      1..10
      |> Enum.each(fn _ -> create_target(%{user: user}) end)

      conn = post(conn, Routes.api_v1_target_path(conn, :create), target: @create_attrs)

      assert json_response(conn, 422)["errors"]["detail"] == "Target maximum limit reached"
    end
  end

  describe "delete target" do
    setup [:create_targets_list]

    test "deletes chosen target if its ours", %{conn: conn, target: target} do
      conn = delete(conn, Routes.api_v1_target_path(conn, :delete, target))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.api_v1_target_path(conn, :show, target))
      end
    end

    test "doesn't delete another user target", %{conn: conn, another_target: another_target} do
      assert_error_sent 404, fn ->
        delete(conn, Routes.api_v1_target_path(conn, :delete, another_target))
      end
    end
  end

  defp create_target(%{user: user}) do
    topic = Fixtures.topic_fixture()
    target = Fixtures.target_fixture(topic: topic, user: user)
    {:ok, target: target}
  end

  defp create_targets_list(%{user: user}) do
    {:ok, target: target} = create_target(%{user: user})
    topic = Fixtures.topic_fixture()
    user = Fixtures.user_fixture()
    another_target = Fixtures.target_fixture(topic: topic, user: user)
    {:ok, another_target: another_target, target: target}
  end
end
