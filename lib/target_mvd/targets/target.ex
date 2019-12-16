defmodule TargetMvd.Targets.Target do
  @moduledoc """
  Target Module
  Targets will relate to a topic.
  For target matching, their topics must coincide
  and be withing the given radius and location.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "targets" do
    field :latitude, :float
    field :longitude, :float
    field :radius, :integer
    field :title, :string
    belongs_to :topic, TargetMvd.Targets.Topic
    belongs_to :user, TargetMvd.Users.User

    timestamps()
  end

  @doc false
  def changeset(target, attrs) do
    target
    |> cast(attrs, [:title, :radius, :latitude, :longitude, :topic_id, :user_id])
    |> validate_required([:title, :radius, :latitude, :longitude])
    |> assoc_constraint(:topic)
    |> assoc_constraint(:user)
  end
end
