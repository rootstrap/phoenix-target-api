defmodule TargetWeb.API.V1.RegistrationController do
  use TargetWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias Target.Users
  alias TargetWeb.ErrorHelpers

  @confirmation_mailer Application.get_env(:target, :confirmation_mailer)

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        send_confirmation_email(conn, user)

        json(conn, %{
          data: %{
            token: conn.private[:api_auth_token],
            renew_token: conn.private[:api_renew_token]
          }
        })

      {:error, changeset, conn} ->
        errors = Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)

        conn
        |> put_status(422)
        |> json(%{error: %{status: 422, message: "Couldn't create user", errors: errors}})
    end
  end

  defp send_confirmation_email(conn, user) do
    Users.send_confirmation_email(user, fn unconfirmed_user ->
      @confirmation_mailer.deliver(conn, user, unconfirmed_user)
    end)
  end
end
