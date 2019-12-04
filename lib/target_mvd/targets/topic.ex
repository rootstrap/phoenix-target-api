defmodule TargetMvd.Targets.Topic do
  @moduledoc """
  Topic Module
  Targets will relate to a topic.
  For target matching, their topics must coincide.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "topics" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(topic, attrs) do
    topic
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end
end
