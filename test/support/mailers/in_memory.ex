defmodule TargetMvdWeb.Mailer.InMemory do
  @moduledoc """
  Email confirmation mailer module for test enviornment.
  Instead of sending emails, will send a messages to self()
  containing the email confirmation token.
  """

  def deliver_email_confirmation(_conn, user, _unconfirmed_user) do
    token = user.email_confirmation_token

    send(self(), {:ok, token})
  end

  def deliver_reset_password(_conn, _user, token) do
    send(self(), {:ok, token})
  end
end
