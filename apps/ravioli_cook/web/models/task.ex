defmodule RavioliCook.Task do
  use RavioliCook.Web, :schema
  alias RavioliCook.Batch
  
  schema "tasks" do
    field :input, :map
    field :result, :map
    belongs_to :batch, Batch

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:input, :result, :batch_id])
    |> validate_required([:input, :batch_id])
  end
end