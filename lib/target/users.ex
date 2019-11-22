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

  def list_users do
    Repo.all(User)
  end

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def current_email_unconfirmed?(%{
        unconfirmed_email: nil,
        email_confirmation_token: token,
        email_confirmed_at: nil
      })
      when not is_nil(token),
      do: false

  def current_email_unconfirmed?(_user),
    do: true

  def send_confirmation_email(user, deliver_confirmation_email) do
    unconfirmed_user = %{user | email: user.unconfirmed_email || user.email}
    deliver_confirmation_email.(unconfirmed_user)
  end
end
