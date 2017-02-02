defmodule RavioliShop.Repo.Migrations.AddPreviousJobIdToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :previous_job_id, :string
    end
  end
end
