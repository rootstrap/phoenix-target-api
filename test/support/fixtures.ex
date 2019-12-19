defmodule TargetMvd.Fixtures do
  @moduledoc """
  Fixtures module for testing support.
  """

  Faker.start()

  alias TargetMvd.Targets

  @pow_config [otp_app: :target_mvd]
  @user_params %{
    "email" => "test@example.com",
    "password" => "secret1234",
    "confirm_password" => "secret1234"
  }
  @topic_params %{
    name: Faker.Industry.industry()
  }
  @target_params %{
    latitude: Faker.Address.latitude(),
    longitude: Faker.Address.longitude(),
    radius: Faker.random_between(10, 200),
    title: "some title"
  }

  def user_fixture(params \\ @user_params) do
    {:ok, user} =
      params
      |> Pow.Operations.create(@pow_config)
      |> elem(1)
      |> PowEmailConfirmation.Ecto.Context.confirm_email(@pow_config)

    user
  end

  def topic_fixture(params \\ @topic_params) do
    {:ok, topic} = Targets.create_topic(params)
    topic
  end

  def target_fixture(params \\ @target_params, topic: topic, user: user) do
    params = Map.merge(params, %{topic_id: topic.id, user_id: user.id})
    {:ok, target} = Targets.create_target(params)
    target
  end
end
