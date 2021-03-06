defmodule TargetMvdWeb.PowMailer do
  @moduledoc false

  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :target_mvd

  import Bamboo.Email

  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: "target_mvd@no-reply.com",
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  def process(email) do
    deliver_now(email)
  end
end
