defmodule KoalaWeb.Authenticate do
  @behaviour Plug
  import Plug.Conn
  alias Koala.Accounts

  def init(opts), do: opts

  def authenticate(nil), do: :error

  def authenticate(user_id) do
    try do
      user = Accounts.get_user!(user_id)
      {:ok, user}
    rescue
      _ in Ecto.NoResultsError -> :error
    end
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    if conn.assigns[:current_user] do
      conn
    else
      case authenticate(user_id) do
        :error ->
          conn
          |> Phoenix.Controller.redirect(to: "/login")
          |> halt()

        _ ->
          {:ok, user} = authenticate(user_id)
          assign(conn, :current_user, user)
      end
    end
  end
end
