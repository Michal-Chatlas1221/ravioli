defmodule RavioliCook.Batch do
  use RavioliCook.Web, :schema
  alias RavioliCook.Task
  
  schema "batches" do
    field :job_id, :integer
    field :resolved, :boolean
    has_many :tasks, Task

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:job_id, :resolved])
    |> validate_required([:job_id])
  end
end