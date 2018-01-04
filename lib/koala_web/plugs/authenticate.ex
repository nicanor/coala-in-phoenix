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

    case authenticate(user_id) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)

      :error ->
        conn
        |> Phoenix.Controller.redirect(to: "/login")
        |> halt()
    end
  end
end
