defmodule KoalaWeb.UserView do
  use KoalaWeb, :view

  # def role_name(type) do
  #   valid_roles()
  #   |> Enum.map(fn {key, value} -> {value, key} end)
  #   |> Enum.into(%{})
  #   |> Map.fetch!(type)
  # end

  def valid_roles do
    [
      {dgettext("accounts", "Admin"), "admin"},
      {dgettext("accounts", "Editor"), "editor"},
      {dgettext("accounts", "Guest"), "guest"}
    ]
  end

end
