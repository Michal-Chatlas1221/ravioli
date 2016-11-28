defmodule RavioliCook.Repo.Migrations.AddBatchTable do
  use Ecto.Migration

  def change do
    create table(:batches, primary_key: false) do
      add :id, :binary_id, primary_key: true	
      add :job_id, :uuid
      add :resolved, :boolean

      timestamps()
    end
  end
end
