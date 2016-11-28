defmodule RavioliShop.Repo.Migrations.AddJobSchema do
  use Ecto.Migration

  def change do
  	create table(:jobs) do
      add :type, :text
      add :input, :text
      add :result, :text
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

  	create index(:jobs, [:user_id])
  end
end
