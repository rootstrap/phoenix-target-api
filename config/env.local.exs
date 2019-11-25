use Mix.Config

System.put_env(
  "SENDGRID_API_KEY",
  "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"
)

System.put_env("CONFIRMATION_URL_REDIRECT_SUCCESS", "https://confirmed-email-url/")
System.put_env("CONFIRMATION_URL_REDIRECT_FAILURE", "https://not-confirmed-email-url/")
# config file needs to return config
config :target, Target.Repo, %{}
