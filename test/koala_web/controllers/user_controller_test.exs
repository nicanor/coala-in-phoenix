defmodule KoalaWeb.UserControllerTest do
  use KoalaWeb.ConnCase

  alias Koala.Accounts

  @create_attrs %{
    password: "some-password",
    password_confirmation: "some-password",
    email: "some@email.com"
  }
  @update_attrs %{
    password: "some-updated-password",
    password_confirmation: "some-updated-password",
    email: "some.updated@email.com",
    role: "admin"
  }
  @invalid_attrs %{password: nil, password_confirmation: nil, email: nil, role: nil}

  setup do
    current_user = fixture(:user)
    conn = assign(build_conn(), :current_user, current_user)
    {:ok, conn: conn, user: current_user}
  end

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "index" do
    test "lists all users", %{conn: conn, user: _} do
      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "Listado de usuarios"
    end
  end

  describe "edit user" do
    test "renders form for editing chosen user", %{conn: conn, user: user} do
      conn = get(conn, user_path(conn, :edit, user))
      assert html_response(conn, 200) =~ "Editar usuario"
    end
  end

  describe "update user" do
    test "redirects when data is valid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @update_attrs)
      assert redirected_to(conn) == user_path(conn, :index)

      conn = get(conn, user_path(conn, :index))
      assert html_response(conn, 200) =~ "some.updated@email.com"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Editar usuario"
    end
  end

  describe "delete user" do
    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, user_path(conn, :delete, user))
      assert redirected_to(conn) == user_path(conn, :index)

      assert_error_sent(500, fn ->
        get(conn, user_path(conn, :edit, user))
      end)
    end
  end
end
