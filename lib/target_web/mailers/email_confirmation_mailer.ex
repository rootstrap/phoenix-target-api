defmodule TargetWeb.EmailConfirmationMailer do
  @moduledoc """
  Email confirmation mailer module. Used to deliver emails to
  recently registered users so they can confirm their emails.
  """

  alias PowEmailConfirmation.Phoenix.Mailer, as: PowEmailConfirmationMailer
  alias TargetWeb.Endpoint
  alias TargetWeb.Router.Helpers, as: Routes

  def deliver(conn, user, unconfirmed_user) do
    url = confirmation_url(user.email_confirmation_token)

    email = PowEmailConfirmationMailer.email_confirmation(conn, unconfirmed_user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  defp confirmation_url(token) do
    Routes.api_v1_confirmation_url(Endpoint, :show, token)
  end
end
