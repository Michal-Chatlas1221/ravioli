defmodule RavioliShop.Job do
  use RavioliShop.Web, :schema
  use Arc.Ecto.Schema

  schema "jobs" do
    field :type, :string
    field :input, :string
    field :result, :string
    field :script_file, RavioliShop.ScriptFile.Type
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :input, :user_id, :result])
    |> cast_attachments(params, [:script_file])
    |> validate_required([:type, :input, :user_id, :script_file])
  end
end
