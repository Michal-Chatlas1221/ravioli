defmodule RavioliShop.ScriptFile do
  use Arc.Definition
  use Arc.Ecto.Definition

  def __storage, do: Arc.Storage.Local

  @versions [:original]

  def validate({file, _}) do
    ~w(.js) |> Enum.member?(Path.extname(file.file_name))
  end

  def storage_dir(_version, {scope, file}) do
    "apps/ravioli_shop/priv/static/uploads/jobs/scripts"
  end
end
