defmodule Koala.CMS.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.CMS.Image
  use Arc.Ecto.Schema

  schema "images" do
    field(:image, KoalaWeb.Image.Type)

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:image])
    |> cast_attachments(attrs, [:image])
    |> validate_required([:image])
  end
end
