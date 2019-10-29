defmodule TargetWeb.Router do
  use TargetWeb, :router
  use Pow.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    pow_routes()
  end

  scope "/api", TargetWeb do
    pipe_through :api
  end
end
