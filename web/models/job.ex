defmodule Ravioli.Job do
  use Ravioli.Web, :schema
  
  schema "jobs" do
    field :type, :string
    field :input, :string
    field :result, :string
    belongs_to :owner, User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :input, :owner])
    |> validate_required([:type, :input, :owner])
  end
end