defmodule TargetWeb.PowMailer do
  @moduledoc false

  alias PowEmailConfirmation.Phoenix.Mailer

  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :target

  import Bamboo.Email

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: "target@no-reply.com",
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  def process(email) do
    deliver_now(email)
  end
end
