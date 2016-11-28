defmodule RavioliCook.Repo.Migrations.AddTasksTable do
  use Ecto.Migration

  def change do
  	create table(:tasks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :input, :json
      add :result, :json
      add :batch_id, references(:batches, on_delete: :delete_all, type: :uuid)

      timestamps()
    end

  	create index(:tasks, [:batch_id])
  end
end
