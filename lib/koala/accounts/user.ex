defmodule Koala.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.Accounts.User


  schema "users" do
    field :email, :string
    field :role, :string
    field :crypted_password, :string
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :crypted_password, :role])
    |> validate_required([:email, :crypted_password, :role])
    |> unique_constraint(:email)
  end
end
