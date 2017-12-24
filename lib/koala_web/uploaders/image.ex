defmodule KoalaWeb.Image do
  use Arc.Definition
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local
  # Include ecto support (requires package arc_ecto installed):

  # To add a thumbnail version:
  @versions [:original, :mini, :thumb]

  # Whitelist file extensions:
  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:original, _) do
    {:convert, "-resize 700 -format jpg", :jpg}
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 64x64^ -gravity center -extent 64x64 -format jpg", :jpg}
  end

  def transform(:mini, _) do
    {:convert, "-strip -thumbnail 32x32^ -gravity center -extent 32x32 -format jpg", :jpg}
  end

  # Override the persisted filenames:
  def filename(version, {file, _scope}) do
    extension = Path.extname(file.file_name)

    file_name =
      file.file_name
      |> Path.basename(extension)
      |> Slugger.slugify_downcase()

    name(version, file_name)
  end

  defp name("original", file_name), do: file_name
  defp name(:original, file_name), do: file_name
  defp name(version, file_name), do: "#{version}-#{file_name}"

  # Override the storage directory:
  def storage_dir(_version, {_file, _scope}) do
    "img/"
  end

  # Provide a default URL if there hasn't been a file uploaded
  # def default_url(version, scope) do
  #   "/images/avatars/default_#{version}.png"
  # end

  # Specify custom headers for s3 objects
  # Available options are [:cache_control, :content_disposition,
  #    :content_encoding, :content_length, :content_type,
  #    :expect, :expires, :storage_class, :website_redirect_location]
  #
  # def s3_object_headers(version, {file, scope}) do
  #   [content_type: Plug.MIME.path(file.file_name)]
  # end
end
