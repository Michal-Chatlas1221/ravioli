defmodule Ravioli.Job do
  use Ravioli.Web, :schema
  
  schema "jobs" do
    field :type, :string
    field :input, :string
    field :result, :string
    belongs_to :user, User

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:type, :input, :user_id, :result])
    |> validate_required([:type, :input, :user_id])
  end
end