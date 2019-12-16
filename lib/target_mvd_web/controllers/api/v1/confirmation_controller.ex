defmodule TargetMvdWeb.API.V1.ConfirmationController do
  @moduledoc false

  use TargetMvdWeb, :controller

  alias PowEmailConfirmation.Plug, as: PowEmailConfirmationPlug

  def show(conn, %{"id" => token}) do
    conn
    |> PowEmailConfirmationPlug.confirm_email(token)
    |> case do
      {:ok, _user, conn} ->
        redirect(conn, external: System.get_env("CONFIRMATION_URL_REDIRECT_SUCCESS"))

      {:error, _changeset, conn} ->
        redirect(conn, external: System.get_env("CONFIRMATION_URL_REDIRECT_FAILURE"))
    end
  end
end
