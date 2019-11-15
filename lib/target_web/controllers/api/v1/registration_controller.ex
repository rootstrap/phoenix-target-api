defmodule TargetWeb.API.V1.RegistrationController do
  use TargetWeb, :controller

  alias Ecto.Changeset
  alias Plug.Conn
  alias Target.Users
  alias TargetWeb.Endpoint
  alias TargetWeb.ErrorHelpers

  def create(conn, %{"user" => user_params}) do
    conn
    |> Pow.Plug.create_user(user_params)
    |> case do
      {:ok, user, conn} ->
        Users.send_confirmation_email(user, conn)

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
end
