defmodule TargetWeb.API.V1.TopicController do
  use TargetWeb, :controller

  alias Target.Targets
  alias Target.Targets.Topic

  action_fallback TargetWeb.FallbackController

  def index(conn, _params) do
    topics = Targets.list_topics()
    render(conn, "index.json", topics: topics)
  end

  def create(conn, %{"topic" => topic_params}) do
    with {:ok, %Topic{} = topic} <- Targets.create_topic(topic_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_topic_path(conn, :show, topic))
      |> render("show.json", topic: topic)
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    topic = Targets.get_topic!(id)
    render(conn, "show.json", topic: topic)
  end

  def update(conn, %{"id" => id, "topic" => topic_params}) do
    topic = Targets.get_topic!(id)

    with {:ok, %Topic{} = topic} <- Targets.update_topic(topic, topic_params) do
      render(conn, "show.json", topic: topic)
    end
  end

  def delete(conn, %{"id" => id}) do
    topic = Targets.get_topic!(id)

    with {:ok, %Topic{}} <- Targets.delete_topic(topic) do
      send_resp(conn, :no_content, "")
    end
  end
end
