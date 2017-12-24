defmodule KoalaWeb.AuthController do
  use KoalaWeb, :controller

  plug(:put_layout, "formal.html")

  alias Koala.Accounts
  alias Koala.Accounts.User

  def new(conn, _params) do
    changeset = Accounts.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_email, user.email)
        |> put_flash(:info, "User loged in successfully.")
        |> redirect(to: publication_path(conn, :index))

      {:error, _} ->
        changeset = Accounts.change_user(%User{})

        conn
        |> put_flash(:info, "Can't login.")
        |> render("new.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user_email)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: public_path(conn, :index))
  end
end
