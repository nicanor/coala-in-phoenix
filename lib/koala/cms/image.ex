defmodule Koala.CMS.Image do
  use Ecto.Schema
  import Ecto.Changeset
  alias Koala.CMS.Image


  schema "images" do
    field :image, :string

    timestamps()
  end

  @doc false
  def changeset(%Image{} = image, attrs) do
    image
    |> cast(attrs, [:image])
    |> validate_required([:image])
  end
end
