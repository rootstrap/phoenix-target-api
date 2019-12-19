defmodule TargetMvdWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use TargetMvdWeb, :controller

  def call(conn, {:error, :maximum_reached}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render("error.json", %{detail: gettext("Target maximum limit reached")})
  end

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(TargetMvdWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(TargetMvdWeb.ErrorView)
    |> render(:"404")
  end
end
