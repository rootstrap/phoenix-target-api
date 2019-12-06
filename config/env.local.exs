use Mix.Config

System.put_env("CONFIRMATION_URL_REDIRECT_SUCCESS", "https://confirmed-email-url/")
System.put_env("CONFIRMATION_URL_REDIRECT_FAILURE", "https://not-confirmed-email-url/")

# config file needs to return config
config :target_mvd, TargetMvd.Repo, %{}
