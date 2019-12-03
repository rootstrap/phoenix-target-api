defmodule TargetMvd.Targets.Target do
  @moduledoc """
  TargetMvd Module
  Targets are created by users, whom declare
  topic, title, radius and location (lat, lon).
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "targets" do
    field :title, :string
    field :radius, :integer
    field :latitude, :float
    field :longitude, :float
    belongs_to :topic, TargetMvd.Targets.Topic
    belongs_to :user, TargetMvd.Users.User

    timestamps()
  end

  @doc false
  def changeset(target_mvd, attrs) do
    target_mvd
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
