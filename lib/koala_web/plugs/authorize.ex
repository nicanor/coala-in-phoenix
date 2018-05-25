defmodule KoalaWeb.Authorize do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, roles) do
    %{role: role} = conn.assigns[:current_user]
    authorized = Enum.member?(roles, role)

    if authorized do
      conn
    else
      conn
      |> Phoenix.Controller.redirect(to: "/")
      |> halt()
    end
  end
end
