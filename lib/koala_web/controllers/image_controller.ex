defmodule KoalaWeb.ImageController do
  use KoalaWeb, :controller

  alias Koala.CMS
  alias Koala.CMS.Image

  def index(conn, _params) do
    images = CMS.list_images()
    render(conn, "index.html", images: images)
  end

  def new(conn, _params) do
    changeset = CMS.change_image(%Image{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"image" => image_params}) do
    case CMS.create_image(image_params) do
      {:ok, image} ->
        conn
        |> put_flash(:info, "Image created successfully.")
        |> redirect(to: image_path(conn, :show, image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, _) do
    conn
    |> put_flash(:info, "Debés seleccionar una imagen.")
    |> new(conn)
  end

  def show(conn, %{"id" => id}) do
    image = CMS.get_image!(id)
    render(conn, "show.html", image: image)
  end

  def delete(conn, %{"id" => id}) do
    image = CMS.get_image!(id)
    {:ok, _image} = CMS.delete_image(image)

    conn
    |> put_flash(:info, "Image deleted successfully.")
    |> redirect(to: image_path(conn, :index))
  end
end
