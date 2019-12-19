defmodule TargetMvdWeb.UserAccountsMailer do
  @moduledoc """
  Email confirmation mailer module. Used to deliver emails to
  recently registered users so they can confirm their emails.
  """

  alias PowEmailConfirmation.Phoenix.Mailer, as: PowEmailConfirmationMailer
  alias PowResetPassword.Phoenix.Mailer, as: PowResetPasswordMailer
  alias TargetMvdWeb.Endpoint
  alias TargetMvdWeb.Router.Helpers, as: Routes

  def deliver_email_confirmation(conn, user, unconfirmed_user) do
    url = confirmation_url(user.email_confirmation_token)

    email = PowEmailConfirmationMailer.email_confirmation(conn, unconfirmed_user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  def deliver_reset_password(conn, user, token) do
    url = password_reset_url(token)

    email = PowResetPasswordMailer.reset_password(conn, user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
    :ok
  end

  defp confirmation_url(token) do
    Routes.api_v1_confirmation_url(Endpoint, :show, token)
  end

  defp password_reset_url(token) do
    Routes.api_v1_reset_password_url(Endpoint, :show, token)
  end
end
