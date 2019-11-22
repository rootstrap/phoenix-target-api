defmodule TargetWeb.APIAuthErrorHandler do
  @moduledoc false

  use TargetWeb, :controller

  def call(conn, :not_authenticated) do
    conn
    |> put_status(401)
    |> json(%{error: %{code: 401, message: "Not authenticated"}})
  end
end
