defmodule TargetWeb.Router do
  use TargetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TargetWeb do
    pipe_through :api
  end
end
