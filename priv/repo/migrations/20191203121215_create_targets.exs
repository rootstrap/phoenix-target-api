defmodule TargetMvd.Repo.Migrations.CreateTargets do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :title, :string
      add :radius, :integer
      add :latitude, :float
      add :longitude, :float
      add :topic_id, references(:topics, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:targets, [:topic_id])
    create index(:targets, [:user_id])
  end
end
