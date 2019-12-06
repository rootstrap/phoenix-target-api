defmodule TargetMvdWeb.API.V1.TargetController do
  use TargetMvdWeb, :controller

  alias Pow.Plug, as: PowPlug
  alias TargetMvd.Targets
  alias TargetMvd.Targets.Target
  alias TargetMvdWeb.ChangesetView

  action_fallback TargetMvdWeb.FallbackController

  def index(conn, _params) do
    current_user = PowPlug.current_user(conn)
    targets = Targets.list_targets(current_user)

    render(conn, "index.json", targets: targets)
  end

  def create(conn, %{"target" => target_params}) do
    current_user_id = PowPlug.current_user(conn).id
    target_params = Map.merge(target_params, %{"user_id" => current_user_id})

    case Targets.create_target(target_params) do
      {:ok, %Target{} = target} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", Routes.api_v1_target_path(conn, :show, target))
        |> render("show.json", target: target)

      {:error, :maximum_reached} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("target_limit_reached.json")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ChangesetView)
        |> render("error.json", %{changeset: changeset})
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
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
