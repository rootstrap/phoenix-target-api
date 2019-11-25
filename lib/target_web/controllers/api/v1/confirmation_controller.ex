defmodule TargetWeb.API.V1.ConfirmationController do
  @moduledoc false

  use TargetWeb, :controller

  alias PowEmailConfirmation.Plug, as: PowEmailConfirmation

  def show(conn, %{"id" => token}) do
    conn
    |> PowEmailConfirmation.confirm_email(token)
    |> case do
      {:ok, _user, conn} ->
        redirect(conn, external: System.get_env("CONFIRMATION_URL_REDIRECT_SUCCESS"))

      {:error, _changeset, conn} ->
        redirect(conn, external: System.get_env("CONFIRMATION_URL_REDIRECT_FAILURE"))
    end
  end
end
