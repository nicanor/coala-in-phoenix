defmodule KoalaWeb.Session do
  def current_user(conn) do
    id = Plug.Conn.get_session(conn, :current_user)
    if id, do: KoalaWeb.Account.get_user_by(id)
  end
end
