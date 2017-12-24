defmodule Koala.Accounts.Registration do
  import Ecto.Changeset
  alias Koala.Accounts.User

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> hash_password
    |> unique_constraint(:email)
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
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
