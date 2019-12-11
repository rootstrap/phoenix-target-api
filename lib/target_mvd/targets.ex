defmodule TargetMvd.Targets do
  @moduledoc """
  The Targets context.
  """

  import Ecto.Query, warn: false

  alias TargetMvd.Repo
  alias TargetMvd.Targets.Target
  alias TargetMvd.Targets.Topic
  alias TargetMvd.Users.User

  def list_topics do
    Repo.all(Topic)
  end

  def get_topic!(id), do: Repo.get!(Topic, id)

  def create_topic(attrs \\ %{}) do
    %Topic{}
    |> Topic.changeset(attrs)
    |> Repo.insert()
  end

  def update_topic(%Topic{} = topic, attrs) do
    topic
    |> Topic.changeset(attrs)
    |> Repo.update()
  end

  def delete_topic(%Topic{} = topic) do
    Repo.delete(topic)
  end

  def change_topic(%Topic{} = topic) do
    Topic.changeset(topic, %{})
  end

  def list_targets(%User{id: user_id}) do
    Target
    |> where(user_id: ^user_id)
    |> Repo.all()
  end

  def get_target!(%User{id: user_id}, id) do
    Repo.get_by!(Target, user_id: user_id, id: id)
  end

  def create_target(attrs \\ %{}) do
    user_id = extract_option(:user_id, attrs)

    targets =
      Target
      |> where(user_id: ^user_id)
      |> Repo.aggregate(:count, :id)

    if targets >= 10 do
      {:error, :maximum_reached}
    else
      %Target{}
      |> Target.changeset(attrs)
      |> Repo.insert()
    end
  end

  def update_target(%Target{} = target, attrs) do
    target
    |> Target.changeset(attrs)
    |> Repo.update()
  end

  def delete_target(%Target{} = target) do
    Repo.delete(target)
  end

  def change_target(%Target{} = target) do
    Target.changeset(target, %{})
  end

  defp extract_option(key, map, default \\ nil)

  defp extract_option(key, map, default) when is_atom(key) do
    map[key] || map[Atom.to_string(key)] || default
  end
end
