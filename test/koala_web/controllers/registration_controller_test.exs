defmodule KoalaWeb.RegistrationControllerTest do
  use KoalaWeb.ConnCase

  alias Koala.Accounts

  @create_attrs %{
    password: "some-password",
    password_confirmation: "some-password",
    email: "some@email.com"
  }

  @invalid_attrs %{password: nil, password_confirmation: nil, email: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  describe "register user form" do
    test "renders form", %{conn: conn} do
      conn = get(conn, registration_path(conn, :register))
      assert html_response(conn, 200) =~ "Register"
    end
  end

  describe "register user" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), user: @create_attrs)

      assert redirected_to(conn) == registration_path(conn, :success)

#      conn = get(conn, user_path(conn, :show, id))
#      assert html_response(conn, 200) =~ "Ver usuario"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, registration_path(conn, :create), user: @invalid_attrs)
      assert html_response(conn, 200) =~ "Register"
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
