defmodule Koala.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.Accounts.User

  @valid_roles ["admin", "editor", "guest"]

  schema "users" do
    field(:email, :string)
    field(:role, :string, default: "guest")
    field(:crypted_password, :string)

    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :role])
    |> validate_required([:email, :role])
    |> validate_format(:email, ~r/@/)
    |> validate_inclusion(:role, @valid_roles)
    |> unique_constraint(:email)
  end
end
