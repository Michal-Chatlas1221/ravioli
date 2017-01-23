defmodule RavioliShop.Repo.Migrations.AddRandomizedResultsAndReplicationRateToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :randomized_results, :boolean, default: false
      add :replication_rate, :float
    end
  end
end
