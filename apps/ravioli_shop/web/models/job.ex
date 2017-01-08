defmodule RavioliShop.Job do
  use RavioliShop.Web, :schema
  use Arc.Ecto.Schema

  schema "jobs" do
    field :type, :string
    field :input, :string
    field :result, :string
    field :script_file, RavioliShop.ScriptFile.Type
    field :divide_server_url, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :input, :user_id, :result, :divide_server_url])
    |> cast_attachments(params, [:script_file])
    |> validate_required([:type, :input, :user_id])
  end
end
