defmodule RavioliShop.Repo.Migrations.AddDivisionAndAggregationTypeToJobs do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :division_type, :string
      add :aggregation_type, :string
    end
  end
end
