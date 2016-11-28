defmodule RavioliCook.Repo.Migrations.AddTasksTable do
  use Ecto.Migration

  def change do
  	create table(:tasks) do
      add :input, :json
      add :result, :json
      add :batch_id, references(:batches, on_delete: :delete_all)

      timestamps()
    end

  	create index(:tasks, [:batch_id])
  end
end
