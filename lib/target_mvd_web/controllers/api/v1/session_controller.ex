defmodule TargetMvdWeb.API.V1.SessionController do
  use TargetMvdWeb, :controller

  alias TargetMvd.Users
  alias TargetMvdWeb.APIAuthPlug

  def create(conn, %{"user" => user_params}) do
    with {:ok, conn} <- Pow.Plug.authenticate_user(conn, user_params),
         true <- email_confirmed?(user_params) do
      json(conn, %{
        data: %{
          token: conn.private[:api_auth_token],
          renew_token: conn.private[:api_renew_token]
        }
      })
    else
      {:error, conn} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid email or password"}})

      false ->
        conn
        |> put_status(403)
        |> json(%{
          error: %{status: 403, message: "You must confirm your email address before logging in."}
        })
    end
  end

  def renew(conn, _params) do
    config = Pow.Plug.fetch_config(conn)

    conn
    |> APIAuthPlug.renew(config)
    |> case do
      {conn, nil} ->
        conn
        |> put_status(401)
        |> json(%{error: %{status: 401, message: "Invalid token"}})

      {conn, _user} ->
        json(conn, %{
          data: %{
            token: conn.private[:api_auth_token],
            renew_token: conn.private[:api_renew_token]
          }
        })
    end
  end

  def delete(conn, _params) do
    {:ok, conn} = Pow.Plug.clear_authenticated_user(conn)

    json(conn, %{data: %{}})
  end

  defp email_confirmed?(%{"email" => email}) do
    email
    |> Users.get_by_email()
    |> Users.current_email_confirmed?()
  end
end
