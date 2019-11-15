defmodule TargetWeb.API.V1.ConfirmationController do
  @moduledoc false
  # use Pow.Extension.Phoenix.Controller.Base
  use TargetWeb, :controller

  alias Plug.Conn
  alias PowEmailConfirmation.Plug

  def show(conn, %{"id" => token}) do
    conn
    |> Plug.confirm_email(token)
    |> case do
      {:ok, _user, conn} ->
        redirect(conn, external: "https://confirmed-email-url/")

      {:error, _changeset, conn} ->
        redirect(conn, external: "https://not-confirmed-email-url/")
    end
  end
end
