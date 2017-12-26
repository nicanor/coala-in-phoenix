defmodule KoalaWeb.Authenticate do
  @behaviour Plug
  import Plug.Conn
  alias Koala.Accounts

  def init(opts), do: opts

  def authenticate(conn) do
    try do
      case get_session(conn, :user_id) do
        nil ->
          :error
        user_id ->
          user = Accounts.get_user!(user_id)
          {:ok, user}
        end
    rescue
      e in Ecto.NoResultsError -> :error
    end
  end

  def call(conn, _opts) do
    case authenticate(conn) do
      {:ok, user} ->
        conn
        |> assign(:current_user, user)
      :error ->
        conn
        |> send_resp(401, "Error 401")
        |> halt
    end
  end
end
