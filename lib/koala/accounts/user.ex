defmodule Koala.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.Accounts.User

  schema "users" do
    field :email, :string
    field :role, :string
    field :crypted_password, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation, :role])
    |> validate_required([:email, :role])
    |> validate_format(:email, ~r/@/)
    |> hash_password
    |> unique_constraint(:email)
  end

  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) when is_binary(password) do
    changeset
    |> validate_required([:password, :password_confirmation])
    |> validate_length(:password, min: 5)
    |> validate_confirmation(:password)
    |> put_change(:crypted_password, Comeonin.Bcrypt.hashpwsalt(password))
  end
  defp hash_password(changeset), do: changeset

  # def password_changeset(model, params \\ %{}) do
  #   model
  #   |> cast(params, ~w(password password_confirmation))
  #   |> hash_password
  # end

end
