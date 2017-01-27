defmodule RavioliShop.Job do
  use RavioliShop.Web, :schema
  use Arc.Ecto.Schema

  schema "jobs" do
    field :type, :string
    field :input, :string
    field :result, :string
    field :division_type, :string
    field :aggregation_type, :string
    # field :script_file, RavioliShop.ScriptFile.Type
    field :script_file, :string
    field :divide_server_url, :string
    field :randomized_results, :boolean, default: false
    field :replication_rate, :float
    belongs_to :user, User

    timestamps()
  end

  @attrs [
    :type, :input, :user_id, :result, :divide_server_url, :division_type,
    :aggregation_type, :script_file
  ]

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @attrs)
    # |> cast_attachments(params, [:script_file])
    |> validate_required([:type, :input, :user_id])
  end
end
