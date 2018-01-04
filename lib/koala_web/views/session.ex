defmodule KoalaWeb.Session do
  def current_user_email(conn) do
    current_user(conn).email
  end

  def current_user_role(conn) do
    current_user(conn).role
  end

  defp current_user(conn) do
    conn.assigns[:current_user]
  end
end
