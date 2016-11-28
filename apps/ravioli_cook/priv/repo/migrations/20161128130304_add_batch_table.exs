defmodule RavioliCook.Repo.Migrations.AddBatchTable do
  use Ecto.Migration

  def change do
    create table(:batches) do
      add :job_id, :integer
      add :resolved, :boolean

      timestamps()
    end
  end
end
