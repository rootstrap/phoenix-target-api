defmodule TargetMvd.Users.User do
  @moduledoc "User Module"

  use Ecto.Schema
  use Pow.Ecto.Schema

  use Pow.Extension.Ecto.Schema,
    extensions: [PowEmailConfirmation]

  schema "users" do
    pow_user_fields()
    field :gender, :string, default: "other"

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> gender_changeset(attrs)
    |> pow_extension_changeset(attrs)
  end

  defp gender_changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:gender])
    |> Ecto.Changeset.validate_inclusion(:gender, ~w(male female other))
  end
end
