defmodule RavioliShop.Repo.Migrations.AddProgressToJob do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :progress, :float
    end
  end
end
