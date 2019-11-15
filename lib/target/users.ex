defmodule Target.Users do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false
  alias Target.Repo

  alias PowEmailConfirmation.Phoenix.{ConfirmationController, Mailer}
  alias PowEmailConfirmation.Plug, as: PowEmailConfirmationPlug
  alias Target.Users.User
  alias TargetWeb.Endpoint
  alias TargetWeb.Router.Helpers, as: Routes

  @spec list_users :: any
  def list_users do
    Repo.all(User)
  end

  def email_confirmed(conn, _params) do
    case PowEmailConfirmationPlug.email_unconfirmed?(conn) do
      true -> {false, conn}
      false -> {true, conn}
    end
  end

  @spec send_confirmation_email(
          %{email: any, email_confirmation_token: any, unconfirmed_email: any},
          Plug.Conn.t()
        ) :: any
  def send_confirmation_email(user, conn) do
    url = confirmation_url(user.email_confirmation_token)
    unconfirmed_user = %{user | email: user.unconfirmed_email || user.email}
    email = Mailer.email_confirmation(conn, unconfirmed_user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  defp confirmation_url(token) do
    Routes.api_v1_confirmation_url(Endpoint, :show, token)
  end
end
