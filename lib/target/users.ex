defmodule Target.Users do
  @moduledoc """
  The User context.
  """

  import Ecto.Query, warn: false

  alias Target.Repo
  alias Target.Users.User

  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def current_email_confirmed?(%User{
        unconfirmed_email: nil,
        email_confirmation_token: token,
        email_confirmed_at: nil
      })
      when not is_nil(token),
      do: false

  def current_email_confirmed?(_user),
    do: true

  def send_confirmation_email(user, deliver_confirmation_email) do
    unconfirmed_user = %{user | email: user.unconfirmed_email || user.email}
    deliver_confirmation_email.(unconfirmed_user)
  end
end
