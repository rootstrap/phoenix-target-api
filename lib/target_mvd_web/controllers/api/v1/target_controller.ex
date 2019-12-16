defmodule TargetMvdWeb.API.V1.TargetController do
  use TargetMvdWeb, :controller

  alias Pow.Plug, as: PowPlug
  alias TargetMvd.Targets
  alias TargetMvd.Targets.Target

  action_fallback TargetMvdWeb.FallbackController

  def index(conn, _params) do
    current_user = PowPlug.current_user(conn)
    targets = Targets.list_targets(current_user)

    render(conn, "index.json", targets: targets)
  end

  def create(conn, %{"target" => target_params}) do
    current_user_id = PowPlug.current_user(conn).id
    target_params = Map.merge(target_params, %{"user_id" => current_user_id})

    with {:ok, %Target{} = target} <- Targets.create_target(target_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.api_v1_target_path(conn, :show, target))
      |> render("show.json", target: target)
    end
  end

  def show(conn, %{"id" => id}) do
    target = Targets.get_target!(PowPlug.current_user(conn), id)
    render(conn, "show.json", target: target)
  end

  def delete(conn, %{"id" => id}) do
    target = Targets.get_target!(PowPlug.current_user(conn), id)

    with {:ok, %Target{}} <- Targets.delete_target(target) do
      send_resp(conn, :no_content, "")
    end
  end
end
