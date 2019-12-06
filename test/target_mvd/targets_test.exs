defmodule TargetMvd.TargetsTest do
  use TargetMvd.DataCase

  alias TargetMvd.Fixtures
  alias TargetMvd.Targets
  alias TargetMvd.Users.User

  describe "topics" do
    alias TargetMvd.Targets.Topic

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def topic_fixture(attrs \\ %{}) do
      {:ok, topic} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Targets.create_topic()

      topic
    end

    test "list_topics/0 returns all topics" do
      topic = topic_fixture()
      assert Targets.list_topics() == [topic]
    end

    test "get_topic!/1 returns the topic with given id" do
      topic = topic_fixture()
      assert Targets.get_topic!(topic.id) == topic
    end

    test "create_topic/1 with valid data creates a topic" do
      assert {:ok, %Topic{} = topic} = Targets.create_topic(@valid_attrs)
      assert topic.name == "some name"
    end

    test "create_topic/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Targets.create_topic(@invalid_attrs)
    end

    test "update_topic/2 with valid data updates the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{} = topic} = Targets.update_topic(topic, @update_attrs)
      assert topic.name == "some updated name"
    end

    test "update_topic/2 with invalid data returns error changeset" do
      topic = topic_fixture()
      assert {:error, %Ecto.Changeset{}} = Targets.update_topic(topic, @invalid_attrs)
      assert topic == Targets.get_topic!(topic.id)
    end

    test "delete_topic/1 deletes the topic" do
      topic = topic_fixture()
      assert {:ok, %Topic{}} = Targets.delete_topic(topic)
      assert_raise Ecto.NoResultsError, fn -> Targets.get_topic!(topic.id) end
    end

    test "change_topic/1 returns a topic changeset" do
      topic = topic_fixture()
      assert %Ecto.Changeset{} = Targets.change_topic(topic)
    end
  end

  describe "targets" do
    alias TargetMvd.Targets.Target

    setup [:create_topic, :create_user]

    @valid_attrs %{
      "latitude" => 120.5,
      "longitude" => 120.5,
      "radius" => 42,
      "title" => "some title"
    }
    @invalid_attrs %{"latitude" => nil, "longitude" => nil, "radius" => nil, "title" => nil}

    def target_fixture(attrs \\ %{}, topic: topic, user: user) do
      {:ok, target} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.merge(%{"topic_id" => topic.id, "user_id" => user.id})
        |> Targets.create_target()

      target
    end

    test "list_targets/0 returns all user targets", %{topic: topic, user: user} do
      target = target_fixture(topic: topic, user: user)
      assert Targets.list_targets(%User{id: user.id}) == [target]
    end

    test "get_target!/1 returns the target with given id", %{topic: topic, user: user} do
      target = target_fixture(topic: topic, user: user)
      assert Targets.get_target!(user, target.id) == target
    end

    test "create_target/1 with valid data creates a target", %{topic: topic, user: user} do
      assert {:ok, %Target{} = target} =
               Targets.create_target(
                 Map.merge(@valid_attrs, %{"topic_id" => topic.id, "user_id" => user.id})
               )

      assert target.latitude == 120.5
      assert target.longitude == 120.5
      assert target.radius == 42
      assert target.title == "some title"
      assert target.topic_id == topic.id
      assert target.user_id == user.id
    end

    test "create_target/1 with invalid data returns error changeset", %{topic: topic, user: user} do
      assert {:error, %Ecto.Changeset{}} =
               Targets.create_target(
                 Map.merge(@invalid_attrs, %{"topic_id" => topic.id, "user_id" => user.id})
               )
    end

    test "delete_target/1 deletes the target", %{topic: topic, user: user} do
      target = target_fixture(topic: topic, user: user)
      assert {:ok, %Target{}} = Targets.delete_target(target)
      assert_raise Ecto.NoResultsError, fn -> Targets.get_target!(user, target.id) end
    end

    test "change_target/1 returns a target changeset", %{topic: topic, user: user} do
      target = target_fixture(topic: topic, user: user)
      assert %Ecto.Changeset{} = Targets.change_target(target)
    end
  end

  defp create_topic(_) do
    topic = Fixtures.topic_fixture()
    {:ok, topic: topic}
  end

  defp create_user(_) do
    user = Fixtures.user_fixture()
    {:ok, user: user}
  end
end
