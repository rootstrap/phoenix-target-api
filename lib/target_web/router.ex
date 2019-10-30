defmodule TargetWeb.Router do
  use TargetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug TargetWeb.APIAuthPlug, otp_app: :target
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated, error_handler: TargetWeb.APIAuthErrorHandler
  end

  scope "/api/v1", TargetWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
  end

  scope "/api/v1", TargetWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # Your protected API endpoints here
  end
end
