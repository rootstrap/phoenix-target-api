defmodule TargetMvdWeb.Router do
  use TargetMvdWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug TargetMvdWeb.APIAuthPlug, otp_app: :target_mvd
  end

  pipeline :api_protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: TargetMvdWeb.APIAuthErrorHandler
  end

  # It reminds the same as long as no admin implementation is available
  pipeline :admin do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: TargetMvdWeb.APIAuthErrorHandler
  end

  scope "/api", TargetMvdWeb do
    pipe_through :api
  end

  scope "/api/v1", TargetMvdWeb.API.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew
    get "/confirm-email/:id", ConfirmationController, :show
  end

  scope "/api/v1", TargetMvdWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected]

    # Your protected API endpoints here
    resources "/topic", TopicController, only: [:show, :index]
    resources "/target", TargetController, only: [:create, :delete, :show, :index]
  end

  scope "/api/v1", TargetMvdWeb.API.V1, as: :api_v1 do
    pipe_through [:api, :api_protected, :admin]

    # Your admin protected API endpoints here
    resources "/topic", TopicController, only: [:create, :delete, :update]
  end
end
