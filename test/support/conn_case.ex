defmodule TargetMvdWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate
  use Phoenix.ConnTest

  alias TargetMvdWeb.APIAuthPlug

  @pow_config [otp_app: :target_mvd]

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias TargetMvdWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint TargetMvdWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(TargetMvd.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(TargetMvd.Repo, {:shared, self()})
    end

    if tags[:authenticated] do
      {:ok, user} =
        %{
          "email" => "test_topic@example.com",
          "password" => "secret1234",
          "confirm_password" => "secret1234"
        }
        |> Pow.Operations.create(@pow_config)
        |> elem(1)
        |> PowEmailConfirmation.Ecto.Context.confirm_email(@pow_config)

      conn = Phoenix.ConnTest.build_conn()
      {authed_conn, _user} = APIAuthPlug.create(conn, user, @pow_config)

      conn =
        conn
        |> put_req_header("accept", "application/json")
        |> put_req_header("authorization", authed_conn.private[:api_auth_token])

      {:ok, conn: conn, user: user}
    else
      {:ok, conn: Phoenix.ConnTest.build_conn()}
    end
  end
end
