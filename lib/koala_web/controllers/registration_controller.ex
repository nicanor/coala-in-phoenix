defmodule KoalaWeb.RegistrationController do
  use KoalaWeb, :controller

  plug(:put_layout, "formal.html")

  alias Koala.Accounts
  alias Koala.Accounts.User

  def register(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "register.html", changeset: changeset)
  end

  def success(conn, _params) do
    render(conn, "success.html")
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: Helpers.registration_path(conn, :success))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "register.html", changeset: changeset)
    end
  end
end
