defmodule Ravioli.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :password, :string
      add :auth_token, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:auth_token])
  end
end
