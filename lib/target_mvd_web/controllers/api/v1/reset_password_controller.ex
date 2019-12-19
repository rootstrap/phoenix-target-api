defmodule TargetMvdWeb.API.V1.ResetPasswordController do
  @moduledoc false
  use TargetMvdWeb, :controller

  alias Ecto.Changeset
  alias PowResetPassword.Plug, as: PowResetPasswordPlug
  alias TargetMvdWeb.ErrorHelpers

  action_fallback TargetMvdWeb.FallbackController

  plug :load_user_from_reset_token when action in [:update, :show]

  @mailer Application.get_env(:target_mvd, :mailer)

  def create(conn, %{"user" => user_params}) do
    case PowResetPasswordPlug.create_reset_token(conn, user_params) do
      {:ok, %{token: token, user: user}, conn} ->
        @mailer.deliver_reset_password(conn, user, token)

        json(conn, %{
          detail: gettext("An email has been sent with instructions to reset password.")
        })

      {:error, _changeset, _conn} ->
        {:error, :unprocessable_entity, dgettext("errors", "User doesn't exist")}
    end
  end

  def update(conn, %{"user" => user_params}) do
    case PowResetPasswordPlug.update_user_password(conn, user_params) do
      {:ok, _user, conn} ->
        json(conn, %{detail: gettext("Password updated successfully.")})

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(422)
        |> json(%{error: %{status: 422, message: "Couldn't update the password", errors: errors}})
    end
  end

  def show(conn, _params) do
    case {:ok, PowResetPasswordPlug.change_user(conn), conn} do
      {:ok, changeset, conn} ->
        conn
        |> assign(:changeset, changeset)
        |> put_status(200)
        |> json(%{status: "ok"})
    end
  end

  defp load_user_from_reset_token(%{params: %{"id" => token}} = conn, _opts) do
    case PowResetPasswordPlug.user_from_token(conn, token) do
      nil ->
        conn
        |> put_status(422)
        |> json(%{error: %{status: 422, message: dgettext("errors", "Invalid token")}})
        |> halt()

      user ->
        PowResetPasswordPlug.assign_reset_password_user(conn, user)
    end
  end
end
