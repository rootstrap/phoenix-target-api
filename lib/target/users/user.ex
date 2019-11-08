defmodule Target.Users.User do
  @moduledoc "User Module"

  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    field :gender, :string, default: "other"

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> changeset_gender(attrs)
  end

  def changeset_gender(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:gender])
    |> Ecto.Changeset.validate_inclusion(:gender, ~w(male female other))
  end
end
