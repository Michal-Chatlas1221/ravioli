defmodule Ravioli.User do
  @moduledoc """
    Let us not worry about docs right now
  """

  use Ravioli.Web, :schema
  alias Comeonin.Bcrypt

  schema "users" do
    field :email, :string
    field :password, :string
    field :auth_token, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email, :password])
    |> validate_required([:email, :password])
    |> encrypt_password()
  end

  def sign_in_changeset(struct, params) do
    struct
    |> cast(params, [:auth_token])
  end

  defp encrypt_password(changeset) do
    hashed_password = Bcrypt.hashpwsalt(changeset.changes.password)
    put_change(changeset, :password, hashed_password)
  end
end
